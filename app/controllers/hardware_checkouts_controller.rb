class HardwareCheckoutsController < ApplicationController
  before_action :set_hardware_checkout, only: [:destroy]
  autocomplete :user, :email, :full => true

  def create
    # Create the checkout from params
    @hardware_checkout = HardwareCheckout.new(hardware_checkout_params)

    # find the hardware item
    @item = @hardware_checkout.hardware_item

    # get email that was initially passed in the user id field
    user_email =  params[:hardware_checkout][:user_id]

    # If there is a problem with the email show an error
    if user_email.nil?
      redirect_to hardware_item_path(@item), alert: 'There was a problem understanding that email'
      return
    else
      # if the email is fine, the make it all lowercase and delete any whitespace
      user_email = user_email.downcase.delete(' ')
    end

    # Check if the item is available
    if @item.count == 0
      redirect_to hardware_item_path(@item), alert: 'This item is no longer available'
      return
    end

    # Check if the email is in our system
    checkout_to_user = User.where(email: user_email).first
    if checkout_to_user.nil?
      redirect_to hardware_item_path(@item), alert: 'Cannot find user with that email'
      return
    else
      # if the email is legit checkout the item to the user and reduce the item count
      @hardware_checkout.user = checkout_to_user
      @item.count -= 1
      @item.save
    end

    # Save the checkout if everything is fine
    if @hardware_checkout.save
      flash[:success] = "Hardware Item Checked Out Successfully"
      redirect_to hardware_item_path(@item)
    else
      flash[:alert] = "Could not checkout hardware item"
    end

  end


  def destroy
    # Find the item that this checkout is related to and then delete it
    @item = @hardware_checkout.hardware_item
    @item.count += 1
    @item.save
    @hardware_checkout.destroy

    # Flash a good message
    flash[:success] = "Hardware Successfully Returned"
    redirect_to hardware_items_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hardware_checkout
      @hardware_checkout = HardwareCheckout.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hardware_checkout_params
      params.require(:hardware_checkout).permit(:user_id, :hardware_item_id, :user_email)
    end
end
