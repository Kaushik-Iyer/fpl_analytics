# app/jobs/update_fixtures_job.rb
require 'http'

class UpdateFixturesJob
    include Sidekiq::Worker
    sidekiq_options queue: 'default'
  
    def perform
      response = HTTP.get("https://fantasy.premierleague.com/api/fixtures/")
      return unless response.status.success?
  
      fixtures_data = JSON.parse(response.body)
      
      ActiveRecord::Base.transaction do
        fixtures_data.each do |fixture_data|
          fixture = Fixture.find_by(code: fixture_data['code'])
          next unless fixture
  
          fixture.update!(
            finished: fixture_data['finished'],
            finished_provisional: fixture_data['finished_provisional'],
            kickoff_time: fixture_data['kickoff_time'],
            minutes: fixture_data['minutes'],
            provisional_start_time: fixture_data['provisional_start_time'],
            started: fixture_data['started'],
            team_a_score: fixture_data['team_a_score'],
            team_h_score: fixture_data['team_h_score']
          )
        end
  
        # Update team points after fixture updates
        Team.update_points if fixtures_data.any? { |f| f['finished'] }
      end
    rescue StandardError => e
      Rails.logger.error("Failed to update fixtures: #{e.message}")
      raise
    end
  end
  