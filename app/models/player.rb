class Player < ApplicationRecord
  belongs_to :team
  belongs_to :position
  has_many :gameweek_stats
  has_many :gameweeks, through: :gameweek_stats

  validates :web_name, presence: true
  
  def now_cost
    read_attribute(:now_cost) / 10.0
  end

  def raw_cost
    read_attribute(:now_cost)
  end

  def fixtures
    team.fixtures
  end

  def points_history
    gameweeks = Gameweek.where(id: Gameweek.current_gameweek.id-5..Gameweek.current_gameweek.id).order(:id)
    gameweeks.map do |gameweek|
      gameweek_stats.find_by(gameweek: gameweek)&.total_points || nil
    end
  end

  def value_history
    gameweeks = Gameweek.where(id: Gameweek.current_gameweek.id-5..Gameweek.current_gameweek.id).order(:id)
    gameweeks.map do |gameweek|
      gameweek_stats.find_by(gameweek: gameweek)&.value || nil
    end
  end

  # create vector embedding for player using gemini api
  def create_embedding
    
  end
end