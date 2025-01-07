class GameweekStatsImporter
  def self.import_all_players
    Player.find_each do |player|
      UpdateGameweekStatsJob.perform_later(player.id)
      Rails.logger.info("Enqueued import for player #{player.id}")
    end
    Rails.logger.info("All player imports have been enqueued.")
  end

  def self.import_for_player(player_id)
    history_data = fetch_player_history(player_id)
    
    history_data.each do |stat|
      gw_stat = GameweekStat.find_or_initialize_by(
        player_id: player_id,
        gameweek_id: stat['round']
      )

      # Basic Stats
      gw_stat.minutes = stat['minutes']
      gw_stat.total_points = stat['total_points']
      gw_stat.goals_scored = stat['goals_scored']
      gw_stat.assists = stat['assists']
      gw_stat.clean_sheets = stat['clean_sheets']
      gw_stat.goals_conceded = stat['goals_conceded']
      gw_stat.own_goals = stat['own_goals']
      gw_stat.penalties_saved = stat['penalties_saved']
      gw_stat.penalties_missed = stat['penalties_missed']
      gw_stat.yellow_cards = stat['yellow_cards']
      gw_stat.red_cards = stat['red_cards']
      gw_stat.saves = stat['saves']
      gw_stat.bonus = stat['bonus']
      gw_stat.bps = stat['bps']

      # Advanced Metrics
      gw_stat.influence = stat['influence'].to_f
      gw_stat.creativity = stat['creativity'].to_f
      gw_stat.threat = stat['threat'].to_f
      gw_stat.ict_index = stat['ict_index'].to_f

      # Expected Stats
      gw_stat.expected_goals = stat['expected_goals'].to_f
      gw_stat.expected_assists = stat['expected_assists'].to_f
      gw_stat.expected_goal_involvements = stat['expected_goal_involvements'].to_f
      gw_stat.expected_goals_conceded = stat['expected_goals_conceded'].to_f

      # Match Context
      gw_stat.opponent_team = stat['opponent_team']
      gw_stat.was_home = stat['was_home']
      gw_stat.team_h_score = stat['team_h_score']
      gw_stat.team_a_score = stat['team_a_score']
      gw_stat.kickoff_time = stat['kickoff_time']

      # Value & Transfers
      gw_stat.value = stat['value']
      gw_stat.transfers_balance = stat['transfers_balance']
      gw_stat.transfers_in = stat['transfers_in']
      gw_stat.transfers_out = stat['transfers_out']

      gw_stat.save!
    end
  rescue StandardError => e
    Rails.logger.error("Failed to import stats for player #{player_id}: #{e.message}")
    raise ImportError, "Failed to import stats: #{e.message}"
  end

  def self.fetch_player_history(player_id)
    response = HTTP.get("https://fantasy.premierleague.com/api/element-summary/#{player_id}/")
    
    unless response.status.success?
      raise ImportError, "API request failed with status #{response.status}"
    end

    data = JSON.parse(response.body)
    raise ImportError, "No history data found" if data['history'].nil?

    data['history']
  end

  class ImportError < StandardError; end
end