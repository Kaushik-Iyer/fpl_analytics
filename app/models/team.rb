class Team < ApplicationRecord
    has_many :players
    has_many :home_fixtures, class_name: 'Fixture', foreign_key: 'team_h', inverse_of: :home_team
    has_many :away_fixtures, class_name: 'Fixture', foreign_key: 'team_a', inverse_of: :away_team

    validates :name, :short_name, presence: true
    validates :code, uniqueness: true

    def fixtures
        Fixture.where('team_h = ? OR team_a = ?', self.id, self.id)
    end

    def self.update_points
        Team.all.each do |team|
            fixtures = team.fixtures.where(finished: true)
            points = fixtures.sum do |fixture|
                if fixture.team_h == team.id
                    fixture.team_h_score > fixture.team_a_score ? 3 : fixture.team_h_score == fixture.team_a_score ? 1 : 0
                else
                    fixture.team_a_score > fixture.team_h_score ? 3 : fixture.team_a_score == fixture.team_h_score ? 1 : 0
                end
            end
            team.update(points: points)
        end
    end

    def create_embedding
        # create vector embedding for team using gemini api
        string = to_text
        result = GeminiClient::EMBEDDING_CLIENT.embed_content({content: { parts: [{text: string}]}})
        update(embedding: result['embedding']['values'])
    end

    def to_text
        [
          name,
          short_name,
          code,
          strength,
          strength_overall_home,
          strength_overall_away,
          strength_attack_home,
          strength_attack_away,
          strength_defence_home,
          strength_defence_away,
          played,
          points
        ].join(' ')
      end

      def self.query_embedding(query)
        # query embedding for team using gemini api
        result = GeminiClient::EMBEDDING_CLIENT.embed_content({content: { parts: [{text: query}]}})
        result['embedding']['values']
      end

    # filepath: /home/kaushik/fpl_analytics/app/models/team.rb
    def self.convert_text_to_sql(query)
      full_query = """
      You are a SQL query generator for a Fantasy Premier League database.
      ONLY give SELECT queries as the output. the database CANNOT be modified.
      
      Relevant tables and their important columns:
      
      teams:
      - id: integer (primary key)
      - name: string (team name)
      - points: integer (current season points)
      - strength_overall_home: string (home performance rating)
      - strength_overall_away: string (away performance rating)
      
      players:
      - id: integer (primary key)
      - web_name: string (display name)
      - team_id: integer (foreign key to teams)
      - total_points: integer (FPL points)
      - goals_scored: integer
      - assists: integer
      - form: float (current form rating)
      
      User Query: #{query}
      
      Generate a SQL query that answers this question by selecting all fields and applying the necessary conditions.
      """

      result = GeminiClient::CHAT_CLIENT.generate_content({contents: {role: 'user', parts: {text: full_query}}})
      sql_query = result['candidates'].first['content']['parts'].first['text'].strip

      # Remove the SQL code block markers if present
      sql_query = sql_query.gsub(/```sql|```/, '').strip

      sql_response = execute_sql_query(sql_query)
      generate_text_response(query, sql_response)
    end

    def self.execute_sql_query(sql_query)
      results = ActiveRecord::Base.connection.execute(sql_query)
      results.map do |row|
        row.symbolize_keys
      end
    end

    def self.generate_text_response(user_query, sql_results)
      results_text = sql_results.map do |result|
        result.map { |key, value| "#{key}: #{value}" }.join(', ')
      end.join("\n")
    
      full_query = """
      You are a text generator for a Fantasy Premier League database.
      Based on the following SQL query results, generate a text response that answers the user's query.
      
      User Query: #{user_query}
      
      SQL Query Results:
      #{results_text}
      """
    
      result = GeminiClient::CHAT_CLIENT.generate_content({contents: {role: 'user', parts: {text: full_query}}})
      result['candidates'].first['content']['parts'].first['text'].strip
    end

end
