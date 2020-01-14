require 'test_helper'

class JudgingControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get judging_new_url
    assert_response :success
  end

  test "should get create" do
    get judging_create_url
    assert_response :success
  end

  test "should get show" do
    get judging_show_url
    assert_response :success
  end

  test "should get edit" do
    get judging_edit_url
    assert_response :success
  end

  test "should get update" do
    get judging_update_url
    assert_response :success
  end

  test "should get destroy" do
    get judging_destroy_url
    assert_response :success
  end

end
