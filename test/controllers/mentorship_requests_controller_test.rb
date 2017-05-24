require 'test_helper'

class MentorshipRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mentorship_request = mentorship_requests(:one)
  end

  test "should get index" do
    get mentorship_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_mentorship_request_url
    assert_response :success
  end

  test "should create mentorship_request" do
    assert_difference('MentorshipRequest.count') do
      post mentorship_requests_url, params: { mentorship_request: { mentor_id: @mentorship_request.mentor_id, status: @mentorship_request.status, title: @mentorship_request.title, type: @mentorship_request.type, user_id: @mentorship_request.user_id } }
    end

    assert_redirected_to mentorship_request_url(MentorshipRequest.last)
  end

  test "should show mentorship_request" do
    get mentorship_request_url(@mentorship_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_mentorship_request_url(@mentorship_request)
    assert_response :success
  end

  test "should update mentorship_request" do
    patch mentorship_request_url(@mentorship_request), params: { mentorship_request: { mentor_id: @mentorship_request.mentor_id, status: @mentorship_request.status, title: @mentorship_request.title, type: @mentorship_request.type, user_id: @mentorship_request.user_id } }
    assert_redirected_to mentorship_request_url(@mentorship_request)
  end

  test "should destroy mentorship_request" do
    assert_difference('MentorshipRequest.count', -1) do
      delete mentorship_request_url(@mentorship_request)
    end

    assert_redirected_to mentorship_requests_url
  end
end
