class DashboardController < ApplicationController
  def index
    @draft_hikes = Hike.where(status: 'draft', host: user).order(date: :asc)
    @review_hikes = Hike.where(status: 'review').order(date: :asc) if user.admin?
    @upcoming_hikes = Hike.where(status: 'published').where('date >= ?', Date.today).order(date: :asc)
  end
end
