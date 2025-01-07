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
end
