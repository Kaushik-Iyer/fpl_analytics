class PlayersController < ApplicationController

    def top_performers
        @players= Player.order(total_points: :desc).limit(10)
        render partial: 'players/top_performers', locals: { players: @players }, layout: false
    end

    def search
        query = "%#{params[:query]}%"
        @players = Player.where("players.web_name LIKE ? OR players.first_name LIKE ? OR players.second_name LIKE ?", query, query, query).limit(10)
        render partial: "players/search_results", locals: { players: @players }, layout: false
      end

    def performance
        @player = Player.find(params[:id])
        @stats = @player.gameweek_stats.order(gameweek_id: :desc).limit(5)
        render partial: 'players/performance', locals: { player: @player, stats: @stats }, layout: false
    end
end