class UpdateGameweekStatsJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default', retry: 3

  def perform(player_id = nil)
    if player_id
      process_single_player(player_id)
    else
      process_all_players
    end
  end

  private

  def process_single_player(player_id)
    GameweekStatsImporter.import_for_player(player_id)
    Rails.logger.info("Imported stats for player #{player_id}")
  rescue StandardError => e
    Rails.logger.error("Failed to import stats for player #{player_id}: #{e.message}")
    raise
  end

  def process_all_players
    Player.find_each.with_index do |player, index|
      # Rate limiting - process 50 players per batch
      if index > 0 && (index % 50).zero?
        sleep(60) # 1 minute pause between batches
      end
      
      UpdateGameweekStatsJob.perform_async(player.id)
    end
    Rails.logger.info("All player imports have been enqueued")
  end
end