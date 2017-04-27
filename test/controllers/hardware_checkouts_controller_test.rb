require 'test_helper'

class HardwareCheckoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hardware_checkout = hardware_checkouts(:one)
  end

  test "should get index" do
    get hardware_checkouts_url
    assert_response :success
  end

  test "should get new" do
    get new_hardware_checkout_url
    assert_response :success
  end

  test "should create hardware_checkout" do
    assert_difference('HardwareCheckout.count') do
      post hardware_checkouts_url, params: { hardware_checkout: { checked_out_by: @hardware_checkout.checked_out_by, item_id: @hardware_checkout.item_id, item_upc: @hardware_checkout.item_upc, user_email: @hardware_checkout.user_email, user_id: @hardware_checkout.user_id } }
    end

    assert_redirected_to hardware_checkout_url(HardwareCheckout.last)
  end

  test "should show hardware_checkout" do
    get hardware_checkout_url(@hardware_checkout)
    assert_response :success
  end

  test "should get edit" do
    get edit_hardware_checkout_url(@hardware_checkout)
    assert_response :success
  end

  test "should update hardware_checkout" do
    patch hardware_checkout_url(@hardware_checkout), params: { hardware_checkout: { checked_out_by: @hardware_checkout.checked_out_by, item_id: @hardware_checkout.item_id, item_upc: @hardware_checkout.item_upc, user_email: @hardware_checkout.user_email, user_id: @hardware_checkout.user_id } }
    assert_redirected_to hardware_checkout_url(@hardware_checkout)
  end

  test "should destroy hardware_checkout" do
    assert_difference('HardwareCheckout.count', -1) do
      delete hardware_checkout_url(@hardware_checkout)
    end

    assert_redirected_to hardware_checkouts_url
  end
end
