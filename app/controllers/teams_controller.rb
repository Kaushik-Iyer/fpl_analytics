class TeamsController < ApplicationController
    def standings
        @teams= Team.all.order(points: :desc).limit(10)
        render partial: 'teams/standings', locals: { teams: @teams }, layout: false
    end
end
