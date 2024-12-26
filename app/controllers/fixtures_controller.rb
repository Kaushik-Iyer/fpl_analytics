class FixturesController < ApplicationController
    def upcoming
        @fixtures = Fixture.includes(:home_team, :away_team)
        .where("kickoff_time > ?", Time.current)
        .order(:kickoff_time)
        .limit(10)
        render partial: 'fixtures/upcoming', locals: { fixtures: @fixtures } , layout: false
    end
end