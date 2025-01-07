class UpdateTeamsJob < ApplicationJob
    queue_as :default

    def perform
        StaticImporter.teams_import
        Rails.logger.info("Imported teams")
    rescue StandardError => e
        Rails.logger.error("Failed to import teams: #{e.message}")
        raise
    end
end