require 'test_helper'

class EventApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event_application = event_applications(:one)
  end

  test "should get index" do
    get event_applications_url
    assert_response :success
  end

  test "should get new" do
    get new_event_application_url
    assert_response :success
  end

  test "should create event_application" do
    assert_difference('EventApplication.count') do
      post event_applications_url, params: { event_application: { food_restrictions: @event_application.food_restrictions, grad_year: @event_application.grad_year, major: @event_application.major, name: @event_application.name, university: @event_application.university, user_id: @event_application.user_id } }
    end

    assert_redirected_to event_application_url(EventApplication.last)
  end

  test "should show event_application" do
    get event_application_url(@event_application)
    assert_response :success
  end

  test "should get edit" do
    get edit_event_application_url(@event_application)
    assert_response :success
  end

  test "should update event_application" do
    patch event_application_url(@event_application), params: { event_application: { food_restrictions: @event_application.food_restrictions, grad_year: @event_application.grad_year, major: @event_application.major, name: @event_application.name, university: @event_application.university, user_id: @event_application.user_id } }
    assert_redirected_to event_application_url(@event_application)
  end

  test "should destroy event_application" do
    assert_difference('EventApplication.count', -1) do
      delete event_application_url(@event_application)
    end

    assert_redirected_to event_applications_url
  end
end
