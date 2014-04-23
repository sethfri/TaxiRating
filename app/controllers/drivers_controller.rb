class DriversController < ApplicationController
  before_action :set_driver, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /drivers
  # GET /drivers.json
  def index
  	if params[:search]
  		@drivers = Driver.search(params[:search]).order("last_name asc")
  	else
	    @drivers = params[:sort] == nil ? Driver.all : Driver.order(sort_column + " " + sort_direction)
	end
	@drivers = @drivers.page(params[:page])
  end

  # GET /drivers/1
  # GET /drivers/1.json
  def show
  end
  
  # GET /drivers/ratings/1
  def ratings
    @driver = Driver.find(params[:id])
  end
  
  # GET /drivers/docs/1
  def documents
    @driver = Driver.find(params[:id])
  end
  
  
  # Download CSV
  def download
      @drivers = Driver.all
      puts "Sending data as csv..."
      send_data @drivers.as_csv, :filename => "drivers.csv"
  end

  # Import CSV
  def import
      Driver.import(params[:file])
      redirect_to root_url, notice: "Drivers imported."
  end

  # GET /drivers/new
  def new
    @driver = Driver.new
  end

  # GET /drivers/1/edit
  def edit
  end

  # POST /drivers
  # POST /drivers.json
  def create
    @driver = Driver.new(driver_params)

    respond_to do |format|
      if @driver.save
        format.html { redirect_to @driver, notice: 'Driver was successfully created.' }
        format.json { render action: 'show', status: :created, location: @driver }
      else
        format.html { render action: 'new' }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drivers/1
  # PATCH/PUT /drivers/1.json
  def update
    respond_to do |format|
      if @driver.update(driver_params)
        format.html { redirect_to @driver, notice: 'Driver was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @driver }
      else
        format.html { render action: 'edit' }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /mobile/images/drivers/:beacon_id
  def get_image
    @driver = Driver.where(:beacon_id => params[:beacon_id]).first
    if !@driver.nil?
        puts "Getting the image for " << @driver.first_name << " " << @driver.last_name
        File.open(@driver.avatar.path, 'rb') do |f|
          send_data f.read, :type => @driver.avatar.content_type, :filename => @driver.last_name, :disposition => "inline"
        end
    end
  end

  # DELETE /drivers/1
  # DELETE /drivers/1.json
  def destroy
    @driver.destroy
    respond_to do |format|
      format.html { redirect_to drivers_url }
      format.json { head :no_content }
    end
  end

  def search
  	@drivers = Driver.search(params[:search])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_driver
      if params[:beacon_id].nil?
          @driver = Driver.find(params[:id])
      else
          @driver = Driver.where(:beacon_id => params[:beacon_id]).first
          puts @driver
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def driver_params
      params.require(:driver).permit(:first_name, :middle_name, :last_name, :avatar, :date_of_birth, :type_id, :address, :city, :state, :zipcode, :race, :sex, :height, :weight, :license, :phone_number, :training_completion_date, :permit_expiration_date, :permit_number, :status, :vehicle_owner, :company_id, :physical_expiration_date, :valid, :beacon_id, :average_rating, :total_ratings)
    end
       
    def sort_column
   	  Driver.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
	
end
