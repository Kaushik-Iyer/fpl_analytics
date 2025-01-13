# app/services/static_importer.rb
class StaticImporter

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
        code = team_data['code']
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
        points: team_data['points'],
        image_url: "https://resources.premierleague.com/premierleague/badges/50/t#{code}.png"
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
          code = player_data['code']
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
            selected_by_percent: player_data['selected_by_percent'],
            code: code,
            image_url: "https://resources.premierleague.com/premierleague/photos/players/110x140/p#{code}.png"
          )
        end
      end
    end
  rescue StandardError => e
    Rails.logger.error("Error importing players: #{e.message}")
    raise e
  end
end
  