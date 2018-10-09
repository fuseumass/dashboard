class HardwareItemsController < ApplicationController
  before_action :set_hardware_item, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, except: [:index, :search]
  before_action :is_feature_enabled

  def search
    if current_user.is_attendee?
      if !current_user.has_slack?
        redirect_to join_slack_path, alert: 'You will need to join slack before you access our hardware inventory.'
      end
    end
    if params[:search].present?
      if is_upc?(params[:search].to_i)
        item = HardwareItem.where(upc: params[:search])
        if !item.first.nil?
          redirect_to hardware_item_path(item.first)
        end
      end
      @hardware_items = HardwareItem.search(params[:search])
    else
      @hardware_items = HardwareItem.all
    end
  end

  def index

    if current_user.is_attendee?
      if !current_user.has_slack?
        redirect_to join_slack_path, alert: 'You will need to join slack before you access our hardware inventory.'
      end
    end

    @all_hardware_items = HardwareItem.all.order(name: :asc)
    @hardware_items = HardwareItem.all.order(name: :asc).paginate(page: params[:page], per_page: 20)
  end

  def show
    # Create a new hardware checkout object in case that some hardware is checked out
    @hardware_checkout = HardwareCheckout.new

    # Get all the people that have checked out items
    @checked_out_items = HardwareCheckout.where(hardware_item: @hardware_item)

    # Do we really need a csv page for one spcific hardware item ???
    respond_to do |format|
      format.html
      format.csv{ send_data @hardware_item.to_csv}
    end

  end

  def new
    @hardware_item = HardwareItem.new
  end


  def edit
  end

  def create
    @hardware_item = HardwareItem.new(hardware_item_params)
    @hardware_item.upc = generate_upc
    if @hardware_item.save
      redirect_to hardware_items_url, notice: 'Hardware item was successfully created.'
    else
      render :new
    end
  end


  def update
    if @hardware_item.update(hardware_item_params)
      redirect_to hardware_items_path, notice: 'Hardware item was successfully updated.'
    else
      render :edit
    end
  end

  def all_checked_out
    @all_hardware_checkouts = HardwareCheckout.all
  end


  def destroy
    @hardware_item.destroy
    redirect_to hardware_items_url, notice: 'Hardware item was successfully destroyed.'
  end

  def is_feature_enabled
    feature_flag = FeatureFlag.find_by(name: 'hardware')
    # Redirect user to index if no feature flag has been found
    if feature_flag.nil?
      redirect_to index_path, notice: 'Hardware is currently not available. Try again later'
    else
      if feature_flag.value == false
        # Redirect user to index if no feature flag is off (false)
        redirect_to index_path, alert: 'Hardware is currently not available. Try again later'
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hardware_item
      begin
        @hardware_item = HardwareItem.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to hardware_items_url, alert: 'Item could not be found'
      end
    end

    def is_upc?(number)
      number > 0 and number < 1000000000
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hardware_item_params
      params.require(:hardware_item).permit(:name, :count, :link, :category, :available, :upc)
    end

    # Randomly and recursively generate a upc number
    def generate_upc
      random_upc = rand(1000000000)
      if(HardwareItem.where(upc: random_upc)).any?
        generate_upc
      else
        random_upc
      end
    end

    # Only admins and organizers have the ability to create, update, edit, show, and destroy hardware items
    def check_permissions
      unless current_user.is_admin? or current_user.is_organizer?
        redirect_to index_path, alert: 'You do not have the permissions to visit this section of hardware.'
      end
    end

end
