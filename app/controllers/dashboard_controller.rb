class DashboardController < ApplicationController
  def index
    @draft_hikes = Hike.where(status: 'draft', host: user).order(datetime: :asc)
    @review_hikes = Hike.where(status: 'review').order(datetime: :asc) if user.admin?
    @upcoming_hikes = Hike.where(status: 'published').where('datetime >= ?', Date.today).order(datetime: :asc)
  end
end
