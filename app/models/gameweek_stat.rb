class GameweekStat < ApplicationRecord
  belongs_to :player
  belongs_to :gameweek

  def value
    read_attribute(:value) / 10.0
  end

  def raw_value
    read_attribute(:value)
  end
  
end
