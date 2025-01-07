class UpdateGameweeksJob < ApplicationJob
    queue_as :default

    def perform
        StaticImporter.gameweeks_import
        Rails.logger.info("Imported gameweeks")
    rescue StandardError => e
        Rails.logger.error("Failed to import gameweeks: #{e.message}")
        raise
    end
end
