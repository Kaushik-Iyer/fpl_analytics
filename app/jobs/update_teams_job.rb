class UpdateTeamsJob
    include Sidekiq::Worker
    sidekiq_options queue: 'default'

    def perform
        StaticImporter.teams_import
        Rails.logger.info("Imported teams")
    rescue StandardError => e
        Rails.logger.error("Failed to import teams: #{e.message}")
        raise
    end
end