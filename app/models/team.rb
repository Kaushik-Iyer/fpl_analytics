class Team < ApplicationRecord
    has_many :players
    has_many :home_fixtures, class_name: 'Fixture', foreign_key: 'team_h', inverse_of: :home_team
    has_many :away_fixtures, class_name: 'Fixture', foreign_key: 'team_a', inverse_of: :away_team

    validates :name, :short_name, presence: true
    validates :code, uniqueness: true

    def fixtures
        Fixture.where('team_h = ? OR team_a = ?', self.id, self.id)
    end
end

# example of team response in api
# {
#     "code": 3,
#     "draw": 0,
#     "form": null,
#     "id": 1,
#     "loss": 0,
#     "name": "Arsenal",
#     "played": 0,
#     "points": 0,
#     "position": 0,
#     "short_name": "ARS",
#     "strength": 4,
#     "team_division": null,
#     "unavailable": false,
#     "win": 0,
#     "strength_overall_home": 1250,
#     "strength_overall_away": 1360,
#     "strength_attack_home": 1260,
#     "strength_attack_away": 1370,
#     "strength_defence_home": 1240,
#     "strength_defence_away": 1350,
#     "pulse_id": 1
# }