require 'test_helper'

class SlackintegrationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get slackintegration_index_url
    assert_response :success
  end

end
