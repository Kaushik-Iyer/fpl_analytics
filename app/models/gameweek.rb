class Gameweek < ApplicationRecord
    has_many :gameweek_stats
    has_many :players, through: :gameweek_stats

    validates :name, presence: true
    validates :deadline_time, presence: true

    def most_selected_player
        Player.find(self.most_selected)
    end

    def most_transferred_in_player
        Player.find(self.most_transferred_in)
    end

    def best_player
        Player.find(self.top_element)
    end

    def self.current_gameweek
        Gameweek.where(finished: true).last
    end

    def self.live
        where("deadline_time <= ? AND finished IS false", Time.current).order(deadline_time: :desc).first
    end
end
