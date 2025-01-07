require 'net/http'
require 'json'

class ManagersController < ApplicationController
  def show
    @manager_id = params[:manager_id]

    if @manager_id.present?
      url = URI("https://fantasy.premierleague.com/api/entry/#{@manager_id}/")
      response = Net::HTTP.get_response(url)
      if response.is_a?(Net::HTTPSuccess)
        @manager_data = JSON.parse(response.body)
      else
        @manager_data = {}
      end
    end

    respond_to do |format|
      format.html do
        render partial: 'managers/manager_info',
               locals: { manager_data: @manager_data },
               layout: false
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          'row3col1',
          partial: 'managers/manager_info',
          locals: { manager_data: @manager_data }
        )
      end
    end
  end
end