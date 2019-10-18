require 'test_helper'

class MentorshipNotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mentorship_notification = mentorship_notifications(:one)
  end

  test "should get index" do
    get mentorship_notifications_url
    assert_response :success
  end

  test "should get new" do
    get new_mentorship_notification_url
    assert_response :success
  end

  test "should create mentorship_notification" do
    assert_difference('MentorshipNotification.count') do
      post mentorship_notifications_url, params: { mentorship_notification: { all: @mentorship_notification.all, tech: @mentorship_notification.tech, user_id: @mentorship_notification.user_id } }
    end

    assert_redirected_to mentorship_notification_url(MentorshipNotification.last)
  end

  test "should show mentorship_notification" do
    get mentorship_notification_url(@mentorship_notification)
    assert_response :success
  end

  test "should get edit" do
    get edit_mentorship_notification_url(@mentorship_notification)
    assert_response :success
  end

  test "should update mentorship_notification" do
    patch mentorship_notification_url(@mentorship_notification), params: { mentorship_notification: { all: @mentorship_notification.all, tech: @mentorship_notification.tech, user_id: @mentorship_notification.user_id } }
    assert_redirected_to mentorship_notification_url(@mentorship_notification)
  end

  test "should destroy mentorship_notification" do
    assert_difference('MentorshipNotification.count', -1) do
      delete mentorship_notification_url(@mentorship_notification)
    end

    assert_redirected_to mentorship_notifications_url
  end
end
