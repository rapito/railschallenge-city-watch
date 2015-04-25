class EmergenciesController < ApplicationController
  before_action :set_emergency, only: [:show, :edit, :update, :destroy]

  # GET /emergencies
  def index
    @emergencies = Emergency.all
  end

  # GET /emergencies/1
  def show
  end

  # POST /emergencies
  def create
    @emergency = Emergency.new(emergency_params)

    respond_to do |format|
      if @emergency.save
        format.html { redirect_to @emergency, notice: 'Emergency was successfully created.' }
        format.json { render :show, status: :created, location: @emergency }
      else
        format.html { render :new }
        format.json { render json: @emergency.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /emergencies/1
  def update
    respond_to do |format|
      if @emergency.update(emergency_params)
        format.html { redirect_to @emergency, notice: 'Emergency was successfully updated.' }
        format.json { render :show, status: :ok, location: @emergency }
      else
        format.html { render :edit }
        format.json { render json: @emergency.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emergencies/1
  # DELETE /emergencies/1.json
  def destroy
    @emergency.destroy
    respond_to do |format|
      format.html { redirect_to emergencies_url, notice: 'Emergency was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_emergency
    begin
      @emergency = Emergency.find(params[:code])
    rescue => ex
      page_not_found
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def emergency_params
    params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
  end
end
