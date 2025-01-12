class UpdateGameweekStatsJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(player_id)
    GameweekStatsImporter.import_for_player(player_id)
    Rails.logger.info("Imported stats for player #{player_id}")
    rescue ImportError => e
        Rails.logger.error("Skipping player #{player_id}: #{e.message}")
        raise e
  end
end