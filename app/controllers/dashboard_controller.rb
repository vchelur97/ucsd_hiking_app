class DashboardController < ApplicationController
  def index
    @upcoming_hikes = Hike.where(status: 'published').where('date >= ?', Date.today).order(date: :asc)
  end
end
