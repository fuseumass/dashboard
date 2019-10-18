require "application_system_test_case"

class MentorshipNotificationsTest < ApplicationSystemTestCase
  setup do
    @mentorship_notification = mentorship_notifications(:one)
  end

  test "visiting the index" do
    visit mentorship_notifications_url
    assert_selector "h1", text: "Mentorship Notifications"
  end

  test "creating a Mentorship notification" do
    visit mentorship_notifications_url
    click_on "New Mentorship Notification"

    fill_in "All", with: @mentorship_notification.all
    fill_in "Tech", with: @mentorship_notification.tech
    fill_in "User", with: @mentorship_notification.user_id
    click_on "Create Mentorship notification"

    assert_text "Mentorship notification was successfully created"
    click_on "Back"
  end

  test "updating a Mentorship notification" do
    visit mentorship_notifications_url
    click_on "Edit", match: :first

    fill_in "All", with: @mentorship_notification.all
    fill_in "Tech", with: @mentorship_notification.tech
    fill_in "User", with: @mentorship_notification.user_id
    click_on "Update Mentorship notification"

    assert_text "Mentorship notification was successfully updated"
    click_on "Back"
  end

  test "destroying a Mentorship notification" do
    visit mentorship_notifications_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Mentorship notification was successfully destroyed"
  end
end
