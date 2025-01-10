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
end
