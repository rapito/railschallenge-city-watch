class RespondersController < ApplicationController
  before_action :set_responder, only: [:show, :edit, :update, :destroy]

  # GET /responders
  def index
    logger.info params
    if params[:show] == 'capacity'
      capacity
    else
      @responders = Responder.all

    end
  end

  # GET /responders/1
  def show
  end

  # GET /responders/new
  def new
    @responder = Responder.new
  end

  # GET /responders/1/edit
  def edit
  end

  # POST /responders
  def create
    @responder = Responder.new(responder_params)

    respond_to do |format|
      if @responder.save
        format.json { render :show, status: :created, location: @responder }
      else
        format.json { render json: wrap_msg_response(@responder.errors), status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /responders/1
  def update
    respond_to do |format|
      if @responder.update(responder_patch_params)
        format.json { render :show, status: :ok, location: @responder }
      else
        format.json { render json: wrap_msg_response(@responder.errors), status: :unprocessable_entity }
      end
    end
  end

  # DELETE /responders/1
  def destroy
    @responder.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_responder
    @responder = Responder.find(params[:name])
    @responder.on_duty = @responder.on_duty ? true : false
  rescue
    page_not_found
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def responder_params
    params.require(:responder).permit(:type, :name, :capacity)
  end

  def responder_patch_params
    params.require(:responder).permit(:on_duty)
  end

  # Need to be able to see the capacity of the emergency responders in the city
  def capacity
    @capacity = {

        'Fire' => Responder.find_by_capacity_status(:fire),
        'Police' => Responder.find_by_capacity_status(:police),
        'Medical' => Responder.find_by_capacity_status(:medical)
    }
    logger.info @capacity

    render :capacity
  end
end
