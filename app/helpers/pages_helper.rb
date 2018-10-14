module PagesHelper

  def is_home_active?
    controller?("pages") and action?("index")
  end

  def is_check_in_active?
    controller?("pages") and action?("check_in")
  end

  def is_mailing_active?
    controller?("emails")
  end

  def is_hardware_active?
    controller?("hardware_items")
  end

  def is_admin_active?
    current_page?(admin_path)
  end

  def is_applications_active?
    controller?("event_applications")
  end

  def is_mentorship_active?
    controller?("mentorship_requests")
  end

  def is_events_active?
    controller?("events")
  end

  def is_projects_active?
      controller?("projects")
  end

  def is_prizes_active?
      controller?("prizes")
  end

  def has_access_to_all_applications?
    (current_user.is_organizer? or current_user.is_admin?) and is_feature_enabled('event_applications')
  end

  def has_access_to_events?
    (current_user.rsvp or current_user.is_admin? or current_user.is_organizer? or current_user.is_mentor?) and is_feature_enabled('events')
  end

  def has_access_to_prizes?
    (current_user.rsvp or current_user.is_admin? or current_user.is_organizer? or current_user.is_mentor?) and is_feature_enabled('prizes')
  end


  def current_user_application
    event_application_path(current_user.event_application)
  end

  def has_access_to_hardware?
    (current_user.rsvp or current_user.is_admin? or current_user.is_organizer? or current_user.is_mentor?) and is_feature_enabled('hardware')
  end

  def has_access_to_mentorship?
    (current_user.check_in or current_user.is_admin? or current_user.is_mentor? or current_user.is_organizer?) and is_feature_enabled('mentorship_requests')
  end

  def has_access_to_projects?
    (current_user.check_in or current_user.is_admin? or current_user.is_organizer? or current_user.is_mentor?)
  end

  def has_access_to_admin?
    current_user.is_admin?
  end

  def has_access_to_check_in?
    (current_user.is_organizer? or current_user.is_admin?) and is_feature_enabled('check_in')
  end

  def has_access_to_applying?
    current_user.is_attendee? and is_feature_enabled('event_applications')
  end

  def already_applied?
    !current_user.event_application.blank? and !current_user.event_application.id.nil?
  end
  # Helper methonds to this helper class. lol so meta
  def controller?(target_controller)
    target_controller.include?(params[:controller])
  end

  def action?(target_action)
    target_action.include?(params[:action])
  end

  def is_feature_enabled(name)
    feature_flag = FeatureFlag.find_by(name: name)
    if feature_flag.nil?
      false
    else
      feature_flag.value
    end
  end

end
