class PlayersController < ApplicationController

  def index
  end

  def top_performers
    @players = Player.order(total_points: :desc).limit(10)
    render partial: 'players/top_performers', locals: { players: @players }, layout: false
  end

  def search
    query = params[:query].downcase
    @players = Player.where(
      "LOWER(web_name) LIKE :query OR 
       LOWER(first_name) LIKE :query OR 
       LOWER(second_name) LIKE :query OR
       LOWER(CONCAT(first_name, ' ', second_name)) LIKE :query",
      query: "%#{query}%"
    ).limit(10)
    
    render partial: "players/search_results", 
           locals: { players: @players }, 
           layout: false
  end

  def performance
    @player = Player.find(params[:id])
    @stats = @player.gameweek_stats.order(gameweek_id: :desc).limit(5)
    render partial: 'players/performance', locals: { player: @player, stats: @stats }, layout: false
  end

  def in_form_players
    position_id = params[:position_id]
    team_id = params[:team_id]
    current_gw = Gameweek.current_gameweek.id
    
    @top_scorers = Player.joins(:gameweek_stats)
                        .where('gameweek_stats.gameweek_id > ?', current_gw - 4)  # Changed > to >=
                        .yield_self { |scope| position_id.present? ? scope.where(position_id: position_id) : scope }
                        .yield_self { |scope| team_id.present? ? scope.where(team_id: team_id) : scope }
                        .group('players.id')
                        .select('players.*, SUM(gameweek_stats.total_points) as form_points')
                        .order('form_points DESC')
                        .limit(3)
  
    @price_risers = Player.joins(:gameweek_stats)
                        .where('gameweek_stats.gameweek_id > ?', current_gw - 4)  # Changed > to >=
                        .yield_self { |scope| position_id.present? ? scope.where(position_id: position_id) : scope }
                        .yield_self { |scope| team_id.present? ? scope.where(team_id: team_id) : scope }
                        .group('players.id')
                        .select('players.*, MAX(gameweek_stats.value) - MIN(gameweek_stats.value) as price_change')
                        .having('MAX(gameweek_stats.value) - MIN(gameweek_stats.value) > 0')
                        .order('price_change DESC')
                        .limit(3)

    respond_to do |format|
      format.html do
        render partial: 'players/in_form_players', 
               locals: { 
                 top_scorers: @top_scorers, 
                 price_risers: @price_risers,
                 position_id: position_id,
                 team_id: team_id 
               }, 
               layout: false
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          'row2col3',
          partial: 'players/in_form_players',
          locals: { 
            top_scorers: @top_scorers, 
            price_risers: @price_risers,
            position_id: position_id,
            team_id: team_id  
          }
        )
      end
    end
  end

  def unavailable
    @unavailable_players = Player.where("status != ?", "a")
                                .includes(:team)
                                .order(total_points: :desc)
                                .page(params[:page])
                                .per(10)
    render partial: 'players/unavailable_players', 
           locals: { players: @unavailable_players }
  end
end