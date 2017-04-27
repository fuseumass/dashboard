class HardwareItemsController < ApplicationController
  before_action :set_hardware_item, only: [:show, :edit, :update, :destroy]

  def search
    if params[:search].present?
      @hardware_items = HardwareItem.search(params[:search])
    else
      @hardware_items = HardwareItem.all
    end
  end

  def index
    @hardware_items = HardwareItem.all

    respond_to do |format|
      format.html
      format.csv{ send_data @hardware_items.to_csv}
    end
  end

  def show
    # Create a new hardware checkout object in case that some hardware is checked out
    @hardware_checkout = HardwareCheckout.new

    # Get all the people that have checked out items
    @checked_out_items = HardwareCheckout.where(item_id: @hardware_item.id)
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


  def destroy
    @hardware_item.destroy
    
    redirect_to hardware_items_url, notice: 'Hardware item was successfully destroyed.' 

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hardware_item
      @hardware_item = HardwareItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hardware_item_params
      params.require(:hardware_item).permit(:name, :count, :link, :category, :available, :upc)
    end

  def generate_upc
    random_upc = rand(1000000000)
    if(HardwareItem.where(upc: random_upc)).any?
      generate_upc
    else
      random_upc
    end
  end

end
