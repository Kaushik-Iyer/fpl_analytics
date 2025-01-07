class UpdatePlayersJob < ApplicationJob
    queue_as :default

    def perform
        StaticImporter.players_import
        Rails.logger.info("Imported players")
    rescue StandardError => e
        Rails.logger.error("Failed to import players: #{e.message}")
        raise
    end
end