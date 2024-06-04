class DashboardController < ApplicationController
  def index
    @draft_hikes = Hike.where(status: 'draft', host: user).order(datetime: :asc)
    @review_hikes = if user.admin?
                      Hike.where(status: 'review').order(datetime: :asc)
                    else
                      Hike.where(status: 'review', host: user).order(datetime: :asc)
                    end
    @upcoming_hikes = Hike.where(status: 'published').where('datetime >= ?', Date.today).order(datetime: :asc)
  end
end
