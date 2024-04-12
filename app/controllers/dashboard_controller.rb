class DashboardController < ApplicationController
  def index
    @hikes = Hike.all
  end
end
