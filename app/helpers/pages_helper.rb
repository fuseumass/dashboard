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
    current_page?(admin_path) or 
    current_page?(feature_flags_path) or
    current_page?(permissions_path) or 
    current_page?(slackintegration_admin_path) or
    controller?("emails")
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

  def is_projects_view_active?
      controller?("projects") and (action?("public") or action?("show") or action?("search") or action?("index"))
  end

  def is_projects_create_active?
    controller?("projects") and not (action?("public") or action?("show") or action?("search") or action?("index"))
  end

  def is_judging_active?
      controller?("judging")
  end

  def is_prizes_active?
      controller?("prizes")
  end

  def has_access_to_all_applications?
    current_user.is_organizer? and check_feature_flag?($Applications)
  end

  def has_access_to_events?
    (current_user.rsvp or current_user.is_organizer? or current_user.is_mentor?) and check_feature_flag?($Events)
  end

  def has_access_to_prizes?
    (current_user.rsvp or current_user.is_organizer? or current_user.is_mentor?) and check_feature_flag?($Prizes)
  end


  def current_user_application
    event_application_path(current_user.event_application)
  end

  def has_access_to_hardware?
    (current_user.rsvp or current_user.is_organizer? or current_user.is_mentor?) and check_feature_flag?($Hardware)
  end

  def has_access_to_mentorship?
    (current_user.check_in or current_user.is_mentor? or current_user.is_organizer?) and check_feature_flag?($MentorshipRequests)
  end

  def has_access_to_projects?
    (current_user.check_in or current_user.is_organizer? or current_user.is_mentor?)
  end

  def has_access_to_admin?
    current_user.is_admin?
  end

  def has_access_to_check_in?
    current_user.is_organizer? and check_feature_flag?($CheckIn)
  end

  def has_access_to_applying?
    current_user.is_attendee? and check_feature_flag?($Applications) and @event_application_mode != 'closed'
  end

  def has_access_to_judging?
    (current_user.is_mentor? or current_user.is_organizer? or current_user.is_admin?) and check_feature_flag?($Judging)
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

  # TODO: Remove this duplicate code somehow
  # Move all feature flag logic and functions to a common module that can be imported everywhere
  def check_feature_flag?(feature_flag_name)
    feature_flag = FeatureFlag.find_by(name: feature_flag_name)
    return feature_flag.value || feature_flag.nil?
  end

end
