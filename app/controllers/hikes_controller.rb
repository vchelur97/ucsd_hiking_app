require 'net/http'
require 'uri'

class HikesController < ApplicationController
  before_action :set_hike, only: %i[show edit update destroy subscribe]
  after_action :admin_review_notification, only: %i[create update]

  DIFFICULTY_MAPPING = {
    1 => 'Easy',
    2 => 'Easy-Moderate',
    3 => 'Moderate',
    4 => 'Moderate-Hard',
    5 => 'Hard'
  }.freeze

  def index
    @upcoming_hikes = Hike.where(status: 'published').where('datetime >= ?', Date.today).order(datetime: :asc)
    @pagy, @hikes = pagy_countless(Hike.where(status: 'published')
                                            .where('datetime < ?', Date.today)
                                            .order(datetime: :desc), items: 3)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
  end

  def new
    @hike = Hike.new
    hike_notification
  end

  def edit
  end

  def create
    @hike = Hike.new(hike_params.except(:graphic))
    @hike.host_id = @user.id
    handle_graphic

    if @hike.save
      redirect_to hike_url(@hike), notice: "Hike was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    handle_graphic
    was_draft = @hike.status == 'draft'

    if @hike.update(hike_params.except(:graphic))
      hike_notification if was_draft && @hike.status == 'published'
      redirect_to hike_url(@hike), notice: "Hike was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @hike.destroy!
    redirect_to root_path, notice: "Hike was successfully deleted."
  end

  def hike_details
    alltrails_link = params[:alltrails_link].strip.split('?').first
    hike_details = CA_HIKE_MAP[alltrails_link]
    title = hike_details['trail_name']
    title = "#{title} (@#{hike_details['area']})" if hike_details['area'].present?
    render json: hike_details.slice('length', 'elevation', 'duration', 'route_type', 'difficulty').merge(title:)
  end

  def subscribe
    case request.method_symbol
    when :post
      if params[:_method] == 'delete'
        @hike.subscribers.delete(@user.id)
      elsif @hike.subscribers.exclude?(@user.id)
        @hike.subscribers << @user.id
      end
      @hike.save
    end
    render partial: 'subscription', locals: { hike: @hike }
  end

  private

  def get_full_url(short_url)
    uri = URI.parse(short_url)
    response = Net::HTTP.get_response(uri)
    return response['location'] if response.code == '302'

    short_url
  end

  def handle_graphic
    return unless hike_params[:graphic].present?

    graphic = "#{@hike.datetime}_#{hike_params[:graphic].original_filename}"
    key = "graphics/#{graphic}"

    blob = ActiveStorage::Blob.find_by(key:)

    blob ||= ActiveStorage::Blob.create_and_upload!(
      io: hike_params[:graphic].open,
      filename: graphic,
      key:
    )

    @hike.graphic.attach(blob)
  end

  def set_hike
    @hike = Hike.find(params[:id])
  end

  def hike_params
    permitted = params.require(:hike).permit(:alltrails_link, :length, :elevation, :duration, :route_type, :difficulty,
                                             :driver_compensation_type, :title, :description, :date, :time,
                                             :trailhead_address, :suggested_items, :notes, :status, :graphic,
                                             :short_description, :metadata, :datetime, :hike_type)
    if permitted[:date].present? && permitted[:time].present?
      permitted[:datetime] =
        "#{permitted[:date]} #{permitted[:time]}".in_time_zone('Pacific Time (US & Canada)').to_datetime
    end
    if permitted[:trailhead_address].present?
      permitted[:trailhead_address] = get_full_url(permitted[:trailhead_address])
    end
    permitted.except(:date, :time)
  end

  def hike_notification
    return unless @hike.published?

    title = "New hike posted! #{@hike.title}"
    body = @hike.short_description
    icon = @hike.graphic.attached? ? url_for(@hike.graphic) : '/assets/hiking_logo.svg'
    link = hike_url(@hike)

    notify_users(User.all, title, body, icon, link)
  end

  def admin_review_notification
    return unless @hike.review?

    title = 'New hike for review'
    body = @hike.title
    icon = @hike.graphic.attached? ? url_for(@hike.graphic) : '/assets/hiking_logo.svg'
    link = hike_url(@hike)

    notify_users(User.all.select(&:admin?), title, body, icon, link)
  end
end
