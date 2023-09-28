require 'test_helper'

class HardwareItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hardware_item = hardware_items(:one)
  end

  test "should get index" do
    get hardware_items_url
    assert_response :success
  end

  test "should get new" do
    get new_hardware_item_url
    assert_response :success
  end

  test "should create hardware_item" do
    assert_difference('HardwareItem.count') do
      post hardware_items_url, params: { hardware_item: { available: @hardware_item.available, category: @hardware_item.category, count: @hardware_item.count, link: @hardware_item.link, name: @hardware_item.name, uid: @hardware_item.uid } }
    end

    assert_redirected_to hardware_item_url(HardwareItem.last)
  end

  test "should show hardware_item" do
    get hardware_item_url(@hardware_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_hardware_item_url(@hardware_item)
    assert_response :success
  end

  test "should update hardware_item" do
    patch hardware_item_url(@hardware_item), params: { hardware_item: { available: @hardware_item.available, category: @hardware_item.category, count: @hardware_item.count, link: @hardware_item.link, name: @hardware_item.name, uid: @hardware_item.uid } }
    assert_redirected_to hardware_item_url(@hardware_item)
  end

  test "should destroy hardware_item" do
    assert_difference('HardwareItem.count', -1) do
      delete hardware_item_url(@hardware_item)
    end

    assert_redirected_to hardware_items_url
  end
end
