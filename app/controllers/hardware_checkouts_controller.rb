class HardwareCheckoutsController < ApplicationController
  before_action :set_hardware_checkout, only: [:show, :edit, :update, :destroy]

  def create
    # Create the checkout from params
    @hardware_checkout = HardwareCheckout.new(hardware_checkout_params)

    # find the hardware item
    @item = HardwareItem.find(@hardware_checkout.item_id)

    # Check if the item is available
    if @item.count == 0
      redirect_to hardware_item_path(@hardware_checkout.item_id), alert: 'This item is no longer available'
      return 
    end
    
    # Check if the email is legit
    checkout_to_user = User.where(email: @hardware_checkout.user_email).first
    if checkout_to_user.nil?
      redirect_to hardware_item_path(@hardware_checkout.item_id), alert: 'Cannot find user with that email'
      return 
    else
      @hardware_checkout.user_id = checkout_to_user.id
      @item.count -= 1
      @item.save
    end

    # Save the checkout if everything is fine
    if @hardware_checkout.save
      flash[:success] = "Hardware Item Checked Out Successfully"
      redirect_to hardware_item_path(@hardware_checkout.item_id)
    else
      flash[:alert] = "Could not checkout hardware item"
    end

  end


  def destroy
    # Find the item that this checkout is related to and then delete it
    @item = HardwareItem.find(@hardware_checkout.item_id)
    @item.count += 1
    @item.save
    @hardware_checkout.destroy

    # Flash a good message 
    flash[:success] = "Hardware Successfully Return"
    redirect_to hardware_item_path(@item)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hardware_checkout
      @hardware_checkout = HardwareCheckout.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hardware_checkout_params
      params.require(:hardware_checkout).permit(:user_id, :user_email, :item_id, :item_upc, :checked_out_by)
    end
end
