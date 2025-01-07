# app/services/fixture_importer.rb
class FixtureImporter
    def self.import(fixtures_data)
      ActiveRecord::Base.transaction do
        fixtures_data.each do |fixture|
          Fixture.find_or_create_by!(code: fixture['code']) do |f|
            f.event = fixture['event']
            f.finished = fixture['finished']
            f.finished_provisional = fixture['finished_provisional']
            f.kickoff_time = fixture['kickoff_time']
            f.minutes = fixture['minutes']
            f.provisional_start_time = fixture['provisional_start_time']
            f.started = fixture['started']
            f.team_a = fixture['team_a']
            f.team_a_score = fixture['team_a_score']
            f.team_h = fixture['team_h']
            f.team_h_score = fixture['team_h_score']
            f.team_h_difficulty = fixture['team_h_difficulty']
            f.team_a_difficulty = fixture['team_a_difficulty']
            f.pulse_id = fixture['pulse_id']
          end
        end
      end
    rescue StandardError => e
      Rails.logger.error("Failed to import fixtures: #{e.message}")
      raise ImportError, "Failed to import fixtures: #{e.message}"
    end
  
    def self.import_from_file(file_path)
      data = JSON.parse(File.read(file_path))
      import(data['fixtures'])
    end
  
    def self.import_from_api
      response = HTTP.get("https://fantasy.premierleague.com/api/fixtures/")
      raise ImportError, "API request failed" unless response.status.success?
  
      data = JSON.parse(response.body)
      import(data)
    end
  
    class ImportError < StandardError; end
  end
  