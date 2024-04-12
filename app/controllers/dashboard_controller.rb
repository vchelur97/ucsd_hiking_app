class DashboardController < ApplicationController
  def index
    @hikes = Hike.where(status: 'published')
  end
end
