# app/services/local_importer.rb
class LocalImporter

  def self.chips_import
    response= HTTP.get("https://fantasy.premierleague.com/api/bootstrap-static/")
    data = JSON.parse(response.body)
    chips_data = data['chips']
    
    ActiveRecord::Base.transaction do
      chips_data.each do |chip_data|
        Chip.find_or_initialize_by(id: chip_data['id']).tap do |chip|
          chip.update!(
            name: chip_data['name'],
            start_event: chip_data['start_event'],
            stop_event: chip_data['stop_event'],
            chip_type: chip_data['chip_type']
          )
        end
      end
    end
  end

  def self.teams_import
    response= HTTP.get("https://fantasy.premierleague.com/api/bootstrap-static/")
    data = JSON.parse(response.body)    
    teams_data = data['teams']
    
    ActiveRecord::Base.transaction do
      teams_data.each do |team_data|
      Team.find_or_initialize_by(id: team_data['id']).tap do |team|
        team.update!(
        name: team_data['name'],
        short_name: team_data['short_name'],
        code: team_data['code'],
        strength: team_data['strength'],
        strength_overall_home: team_data['strength_overall_home'],
        strength_overall_away: team_data['strength_overall_away'],
        strength_attack_home: team_data['strength_attack_home'],
        strength_attack_away: team_data['strength_attack_away'],
        strength_defence_home: team_data['strength_defence_home'],
        strength_defence_away: team_data['strength_defence_away'],
        played: team_data['played'],
        points: team_data['points']
        )
      end
      end
    end
  end

  def self.gameweeks_import
    response= HTTP.get("https://fantasy.premierleague.com/api/bootstrap-static/")
    data = JSON.parse(response.body)
    gameweeks_data = data['events']
    ActiveRecord::Base.transaction do
      gameweeks_data.each do |gameweek_data|
      Gameweek.find_or_initialize_by(id: gameweek_data['id']).tap do |gameweek|
        gameweek.update!(
          name: gameweek_data['name'],
          deadline_time: gameweek_data['deadline_time'],
          average_entry_score: gameweek_data['average_entry_score'],
          finished: gameweek_data['finished'],
          is_current: gameweek_data['is_current'],
          is_next: gameweek_data['is_next'],
          is_previous: gameweek_data['is_previous'],
          highest_score: gameweek_data['highest_score'],
          most_selected: gameweek_data['most_selected'],
          most_transferred_in: gameweek_data['most_transferred_in'],
          top_element: gameweek_data['top_element'],
          transfers_made: gameweek_data['transfers_made']
        )
      end
      end
    end
  end

  def self.players_import
    response= HTTP.get("https://fantasy.premierleague.com/api/bootstrap-static/")
    data = JSON.parse(response.body)
    players_data = data['elements']
    ActiveRecord::Base.transaction do
      players_data.each do |player_data|
        Player.find_or_initialize_by(id: player_data['id']).tap do |player|
          player.update!(
            first_name: player_data['first_name'],
            second_name: player_data['second_name'],
            web_name: player_data['web_name'],
            team_id: player_data['team'],
            position_id: player_data['element_type'],
            now_cost: player_data['now_cost'],
            total_points: player_data['total_points'],
            goals_scored: player_data['goals_scored'],
            assists: player_data['assists'],
            clean_sheets: player_data['clean_sheets'],
            minutes: player_data['minutes'],
            status: player_data['status'],
            news: player_data['news'],
            news_added: player_data['news_added'],
            form: player_data['form'],
            points_per_game: player_data['points_per_game'],
            selected_by_percent: player_data['selected_by_percent']
          )
        end
      end
    end
  rescue StandardError => e
    Rails.logger.error("Error importing players: #{e.message}")
    raise e
  end

  private

  def self.teams_format()
    #=> Team(id: integer, name: string, short_name: string, code: string, strength: string, strength_overall_home: string, strength_overall_away: string, strength_attack_home: string, strength_attack_away: string, strength_defence_home: string, strength_defence_away: string, played: string, points: string, created_at: datetime, updated_at: datetime)

    {
      "code": 3,
      "draw": 0,
      "form": null,
      "id": 1,
      "loss": 0,
      "name": "Arsenal",
      "played": 0,
      "points": 0,
      "position": 0,
      "short_name": "ARS",
      "strength": 4,
      "team_division": null,
      "unavailable": false,
      "win": 0,
      "strength_overall_home": 1250,
      "strength_overall_away": 1360,
      "strength_attack_home": 1260,
      "strength_attack_away": 1370,
      "strength_defence_home": 1240,
      "strength_defence_away": 1350,
      "pulse_id": 1
  }
  end

  def self.players_format()
    #=> Player(id: integer, first_name: string, second_name: string, web_name: string, team_id: integer, element_type: integer, now_cost: decimal, total_points: integer, goals_scored: integer, assists: integer, clean_sheets: integer, minutes: integer, status: string, news: string, news_added: datetime, form: float, points_per_game: float, selected_by_percent: float, created_at: datetime, updated_at: datetime)

      {
      "can_transact": true,
      "can_select": true,
      "chance_of_playing_next_round": 100,
      "chance_of_playing_this_round": 100,
      "code": 223094,
      "cost_change_event": -1,
      "cost_change_event_fall": 1,
      "cost_change_start": -2,
      "cost_change_start_fall": 2,
      "dreamteam_count": 3,
      "element_type": 4,
      "ep_next": "4.1",
      "ep_this": "4.1",
      "event_points": 2,
      "first_name": "Erling",
      "form": "3.6",
      "id": 351,
      "in_dreamteam": true,
      "news": "",
      "news_added": "2024-09-13T15:00:06.985607Z",
      "now_cost": 148,
      "photo": "223094.jpg",
      "points_per_game": "6.0",
      "removed": false,
      "second_name": "Haaland",
      "selected_by_percent": "34.5",
      "special": false,
      "squad_number": null,
      "status": "a",
      "team": 13,
      "team_code": 43,
      "total_points": 102,
      "transfers_in": 2864316,
      "transfers_in_event": 15025,
      "transfers_out": 4902372,
      "transfers_out_event": 246194,
      "value_form": "0.2",
      "value_season": "6.9",
      "web_name": "Haaland",
      "region": 161,
      "team_join_date": "2022-07-01",
      "minutes": 1529,
      "goals_scored": 13,
      "assists": 1,
      "clean_sheets": 3,
      "goals_conceded": 25,
      "own_goals": 0,
      "penalties_saved": 0,
      "penalties_missed": 0,
      "yellow_cards": 2,
      "red_cards": 0,
      "saves": 0,
      "bonus": 15,
      "bps": 451,
      "influence": "534.8",
      "creativity": "156.8",
      "threat": "919.0",
      "ict_index": "161.3",
      "starts": 17,
      "expected_goals": "13.10",
      "expected_assists": "0.91",
      "expected_goal_involvements": "14.01",
      "expected_goals_conceded": "25.31",
      "influence_rank": 5,
      "influence_rank_type": 1,
      "creativity_rank": 127,
      "creativity_rank_type": 13,
      "threat_rank": 2,
      "threat_rank_type": 1,
      "ict_index_rank": 4,
      "ict_index_rank_type": 1,
      "corners_and_indirect_freekicks_order": null,
      "corners_and_indirect_freekicks_text": "",
      "direct_freekicks_order": 3,
      "direct_freekicks_text": "",
      "penalties_order": 1,
      "penalties_text": "",
      "expected_goals_per_90": 0.77,
      "saves_per_90": 0,
      "expected_assists_per_90": 0.05,
      "expected_goal_involvements_per_90": 0.82,
      "expected_goals_conceded_per_90": 1.49,
      "goals_conceded_per_90": 1.47,
      "now_cost_rank": 1,
      "now_cost_rank_type": 1,
      "form_rank": 83,
      "form_rank_type": 14,
      "points_per_game_rank": 7,
      "points_per_game_rank_type": 2,
      "selected_rank": 4,
      "selected_rank_type": 2,
      "starts_per_90": 1,
      "clean_sheets_per_90": 0.18
    }
  end
  def self.gameweek_format()
    #irb(main):009:0> Gameweek => Gameweek(id: integer, name: string, deadline_time: datetime, average_entry_score: integer, finished: boolean, is_current: boolean, is_next: boolean, is_previous: boolean, highest_score: integer, most_selected: integer, most_transferred_in: integer, top_element: integer, transfers_made: integer, created_at: datetime, updated_at: datetime)
    {
      "id": 1,
      "name": "Gameweek 1",
      "deadline_time": "2024-08-16T17:30:00Z",
      "release_time": null,
      "average_entry_score": 57,
      "finished": true,
      "data_checked": true,
      "highest_scoring_entry": 3546234,
      "deadline_time_epoch": 1723829400,
      "deadline_time_game_offset": 0,
      "highest_score": 127,
      "is_previous": false,
      "is_current": false,
      "is_next": false,
      "cup_leagues_created": false,
      "h2h_ko_matches_created": false,
      "can_enter": false,
      "can_manage": false,
      "released": true,
      "ranked_count": 8597356,
      "overrides": {
          "rules": {},
          "scoring": {},
          "element_types": [],
          "pick_multiplier": null
      },
      "chip_plays": [
          {
              "chip_name": "bboost",
              "num_played": 144974
          },
          {
              "chip_name": "3xc",
              "num_played": 221430
          }
      ],
      "most_selected": 401,
      "most_transferred_in": 27,
      "top_element": 328,
      "top_element_info": {
          "id": 328,
          "points": 14
      },
      "transfers_made": 0,
      "most_captained": 351,
      "most_vice_captained": 351
  }
  end
end
  