# app/models/fixture.rb
class Fixture < ApplicationRecord
    belongs_to :home_team, class_name: 'Team', foreign_key: 'team_h', inverse_of: :home_fixtures
    belongs_to :away_team, class_name: 'Team', foreign_key: 'team_a', inverse_of: :away_fixtures
    belongs_to :gameweek, foreign_key: 'event', optional: true
  
    validates :team_h, :team_a, presence: true
  end
  