class LiveGameweekStatsJob
    include Sidekiq::Worker
    sidekiq_options queue: 'default', retry: 3
  
    def perform
      return unless Gameweek.live.present?
      
      current_gameweek = Gameweek.live
      Rails.logger.info "Processing live stats for gameweek #{current_gameweek.id}"
      
      begin
        response = HTTP.timeout(30).get("https://fantasy.premierleague.com/api/event/#{current_gameweek.id}/live/")
        raise "API Error" unless response.status.success?
        
        data = JSON.parse(response.body)
        return if data['elements'].blank?
        
        GameweekStat.transaction do
          process_gameweek_stats(data['elements'], current_gameweek.id)
        end
        
        Rails.logger.info "Successfully updated live stats for gameweek #{current_gameweek.id}"
      rescue => e
        Rails.logger.error "Failed to update live stats: #{e.message}"
        raise
      end

      # Update player points
      Player.all.each do |player|
        player.update_points_live
      end

    end
    
    private
  
    def process_gameweek_stats(elements, gameweek_id)
      elements.each_slice(100) do |batch|
        stats_to_update = batch.map do |element|
          stats = element['stats']
          {
            player_id: element['id'],
            gameweek_id: gameweek_id,
            minutes: stats['minutes'],
            total_points: stats['total_points'],
            goals_scored: stats['goals_scored'],
            assists: stats['assists'],
            clean_sheets: stats['clean_sheets'],
            goals_conceded: stats['goals_conceded'],
            own_goals: stats['own_goals'],
            penalties_saved: stats['penalties_saved'],
            yellow_cards: stats['yellow_cards'],
            red_cards: stats['red_cards'],
            saves: stats['saves'],
            bonus: stats['bonus'],
            bps: stats['bps'],
            influence: stats['influence'].to_f,
            creativity: stats['creativity'].to_f,
            threat: stats['threat'].to_f,
            ict_index: stats['ict_index'].to_f,
            starts: stats['starts'],
            expected_goals: stats['expected_goals'].to_f,
            expected_assists: stats['expected_assists'].to_f,
            expected_goal_involvements: stats['expected_goal_involvements'].to_f,
            expected_goals_conceded: stats['expected_goals_conceded'].to_f
          }
        end
        
        GameweekStat.upsert_all(
          stats_to_update,
          unique_by: [:player_id, :gameweek_id],
          returning: false
        )
      end
    end
  end