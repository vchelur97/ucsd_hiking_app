class HikesController < ApplicationController
  before_action :set_hike, only: %i[ show edit update destroy ]

  # GET /hikes or /hikes.json
  def index
    @hikes = Hike.all
  end

  # GET /hikes/1 or /hikes/1.json
  def show
  end

  # GET /hikes/new
  def new
    @hike = Hike.new
  end

  # GET /hikes/1/edit
  def edit
  end

  # POST /hikes or /hikes.json
  def create
    @hike = Hike.new(hike_params)

    respond_to do |format|
      if @hike.save
        format.html { redirect_to hike_url(@hike), notice: "Hike was successfully created." }
        format.json { render :show, status: :created, location: @hike }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @hike.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hikes/1 or /hikes/1.json
  def update
    respond_to do |format|
      if @hike.update(hike_params)
        format.html { redirect_to hike_url(@hike), notice: "Hike was successfully updated." }
        format.json { render :show, status: :ok, location: @hike }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @hike.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hikes/1 or /hikes/1.json
  def destroy
    @hike.destroy!

    respond_to do |format|
      format.html { redirect_to hikes_url, notice: "Hike was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hike
      @hike = Hike.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def hike_params
      params.require(:hike).permit(:title, :description, :date, :time, :user_id, :length, :elevation, :route_type, :duration, :trailhead_address, :alltrails_link, :suggested_items, :driver_compensation_type, :notes, :metadata)
    end
end
