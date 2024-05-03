class HikesController < ApplicationController
  before_action :set_hike, only: %i[show edit update destroy]
  DIFFICULTY_MAPPING = {
    1 => 'Easy',
    2 => 'Easy-Moderate',
    3 => 'Moderate',
    4 => 'Moderate-Hard',
    5 => 'Hard'
  }.freeze

  def index
    @upcoming_hikes = Hike.where(status: 'published').where('date >= ?', Date.today).order(date: :asc)
    @pagy, @hikes = pagy_countless(Hike.where(status: 'published')
                                            .where('date < ?', Date.today)
                                            .order(date: :desc), items: 3)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
  end

  def new
    @hike = Hike.new
  end

  def edit
  end

  def create
    @hike = Hike.new(hike_params)
    @hike.host_id = @user.id

    if @hike.save
      redirect_to hike_url(@hike), notice: "Hike was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @hike.update(hike_params)
      redirect_to hike_url(@hike), notice: "Hike was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @hike.destroy!
    redirect_to hikes_url, notice: "Hike was successfully destroyed."
  end

  def hike_details
    alltrails_link = params[:alltrails_link].strip.split('?').first
    hike_details = CA_HIKE_MAP[alltrails_link]
    title = hike_details['trail_name']
    title = "#{title} (@#{hike_details['area']})" if hike_details['area'].present?
    render json: hike_details.slice('length', 'elevation', 'duration', 'route_type', 'difficulty').merge(title:)
  end

  private

  def set_hike
    @hike = Hike.find(params[:id])
  end

  def hike_params
    params.require(:hike).permit(:alltrails_link, :length, :elevation, :duration, :route_type, :difficulty,
                                 :driver_compensation_type, :title, :description, :date, :time,
                                 :trailhead_address, :suggested_items, :notes, :status, :graphic, :metadata)
  end
end
