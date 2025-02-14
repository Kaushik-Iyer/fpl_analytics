class MetricsController < ApplicationController
  def show
    @grafana_url = 'http://localhost:3001/d/cech9dh8nabk0a/fpl-application-dashboard?orgId=1'
    render layout: false
  end
end