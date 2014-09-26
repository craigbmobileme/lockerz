class LockersController < ApplicationController
  before_action :set_locker, only: [:show, :edit, :update, :destroy]

  # GET /lockers
  # GET /lockers.json
  def index
    @lockers = Locker.all
  end

  # GET /lockers/1
  # GET /lockers/1.json
  def show
  end

  # GET /lockers/new
  def new
    @locker = Locker.new
  end

  # POST /lockers
  # POST /lockers.json
  def create
    @locker = Locker.new(locker_params)

    respond_to do |format|
      if @locker.save
        format.html { redirect_to @locker, notice: "Successfully Checked In A Bag" }
        format.json { render :show, status: :created, location: @locker }
      else
        format.html { render :new }
        format.json { render json: @locker.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /lockers/find
  def find 
    @query = params[:q]
    if !@query.nil?
      @locker = Locker.find_by_code(@query.strip.downcase)
    end
    if !@locker.nil?
      @locker_found = true
      @locker_bag_size = @locker.bag_size
      @locker_size = @locker.size
      @locker_number = @locker.number

      # free the locker number
      # I wanted to do this using the before_destroy callback but it is not working, the locker number on the self
      # object is gone fo some reason, so I am making an explicit call in the sake of time
      @locker.free_locker_number
      # kill the locker from the db after we retrieve a bag
      @locker.destroy
    else
      @locker_found = false
    end

    respond_to do |format|
      format.html {render :find}
    end

  end

  # PATCH/PUT /lockers/1
  # PATCH/PUT /lockers/1.json
  def update
    respond_to do |format|
      if @locker.update(locker_params)
        format.html { redirect_to @locker, notice: 'Locker was successfully updated.' }
        format.json { render :show, status: :ok, location: @locker }
      else
        format.html { render :edit }
        format.json { render json: @locker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lockers/1
  # DELETE /lockers/1.json
  def destroy
    @locker.destroy
    respond_to do |format|
      format.html { redirect_to lockers_url, notice: 'Locker was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_locker
      @locker = Locker.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # Allow the size parameter
    def locker_params
      params[:locker].permit(:bag_size)
    end


end
