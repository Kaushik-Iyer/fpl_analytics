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

end


# Example of gameweek field in the response
# {
#     "id": 1,
#     "name": "Gameweek 1",
#     "deadline_time": "2024-08-16T17:30:00Z",
#     "release_time": null,
#     "average_entry_score": 57,
#     "finished": true,
#     "data_checked": true,
#     "highest_scoring_entry": 3546234,
#     "deadline_time_epoch": 1723829400,
#     "deadline_time_game_offset": 0,
#     "highest_score": 127,
#     "is_previous": false,
#     "is_current": false,
#     "is_next": false,
#     "cup_leagues_created": false,
#     "h2h_ko_matches_created": false,
#     "can_enter": false,
#     "can_manage": false,
#     "released": true,
#     "ranked_count": 8597356,
#     "overrides": {
#         "rules": {},
#         "scoring": {},
#         "element_types": [],
#         "pick_multiplier": null
#     },
#     "chip_plays": [
#         {
#             "chip_name": "bboost",
#             "num_played": 144974
#         },
#         {
#             "chip_name": "3xc",
#             "num_played": 221430
#         }
#     ],
#     "most_selected": 401,
#     "most_transferred_in": 27,
#     "top_element": 328,
#     "top_element_info": {
#         "id": 328,
#         "points": 14
#     },
#     "transfers_made": 0,
#     "most_captained": 351,
#     "most_vice_captained": 351
# }