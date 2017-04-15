require 'test_helper'

class NavigationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get navigation_index_url
    assert_response :success
  end

  test "should get about" do
    get navigation_about_url
    assert_response :success
  end

end
