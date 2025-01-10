class ChatService
    def self.respond(user_query)
      sql_query = generate_sql_query(user_query)
      sql_results = execute_sql_query(sql_query)
      generate_text_response(user_query, sql_results)
    rescue StandardError => e
      "An error occurred"
    end
  
    def self.generate_sql_query(user_query)
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

  fixtures:
  - id: integer (primary key)
  - code: integer
  - event: integer
  - finished: boolean
  - team_h_score: integer
  - team_a_score: integer

  gameweek_stats:
  - id: integer (primary key)
  - player_id: integer
  - gameweek_id: integer
  - minutes: integer
  - goals_scored: integer
  - assists: integer
  - total_points: integer
  - expected_goals: float
  - expected_assists: float

  positions:
    - id: integer (primary key)
    - plural_name: string

  User Query: #{user_query}
  
  Generate a SQL query that answers this question by selecting all fields and applying the necessary conditions.
  """
    
      result = GeminiClient::CHAT_CLIENT.generate_content({contents: {role: 'user', parts: {text: full_query}}})
      sql_query = result['candidates'].first['content']['parts'].first['text'].strip
    
      # Remove the SQL code block markers if present
      sql_query.gsub(/```sql|```/, '').strip
    rescue StandardError => e
      raise "Failed to generate SQL query: #{e.message}"
    end
  
    def self.execute_sql_query(sql_query)
      results = ActiveRecord::Base.connection.execute(sql_query)
      results.map do |row|
        row.symbolize_keys
      end
    rescue StandardError => e
      raise "Failed to execute SQL query: #{e.message}"
    end
  
    def self.generate_text_response(user_query, sql_results)
      results_text = sql_results.map do |result|
        result.map { |key, value| "#{key}: #{value}" }.join(', ')
      end.join("\n")
    
      full_query = """
      You are a text generator for a Fantasy Premier League database.
      Based on the following SQL query results, generate a text response that answers the user's query. Don't give responses that show random id numbers, and if you dont get a proper response, just say 'I am sorry, I could not find the information you are looking for'
      
      User Query: #{user_query}
      
      SQL Query Results:
      #{results_text}
      """
    
      result = GeminiClient::CHAT_CLIENT.generate_content({contents: {role: 'user', parts: {text: full_query}}})
      result['candidates'].first['content']['parts'].first['text'].strip
    rescue StandardError => e
      raise "Failed to generate text response: #{e.message}"
    end
  end