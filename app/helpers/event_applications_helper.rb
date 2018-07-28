module EventApplicationsHelper

  def denied_is_active?(params)
    params[:status].present? and params[:status] == 'denied'
  end

  def waitlisted_is_active?(params)
    params[:status].present? and params[:status] == 'waitlisted'
  end

  def accepted_is_active?(params)
    params[:status].present? and params[:status] == 'accepted'
  end

  def undecided_is_active?(params)
    params[:status].present? and params[:status] == 'undecided'
  end

  def rsvp_is_active?(params)
    params[:rsvp].present?
  end

  def flagged_is_active?(params)
    params[:flagged].present?
  end

  def all_is_active?(params)
    !(params[:status].present? or params[:flagged].present? or params[:rsvp].present?)
  end

  def editing_application?
    params[:action] == 'edit'
  end

  def has_permissions_to_edit
    current_user.is_admin?
  end

  def admin_or_organizer?
    current_user.user_type == 'admin' || current_user.user_type == 'organizer'
  end
end