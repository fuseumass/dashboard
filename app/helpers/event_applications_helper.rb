module EventApplicationsHelper

  def denied_is_active?(params)
    params[:status].present? && params[:status] == 'denied'
  end

  def waitlisted_is_active?(params)
    params[:status].present? && params[:status] == 'waitlisted'
  end

  def accepted_is_active?(params)
    params[:status].present? && params[:status] == 'accepted'
  end

  def undecided_is_active?(params)
    params[:status].present? && params[:status] == 'undecided'
  end

  def rsvp_is_active?(params)
    params[:rsvp].present?
  end

  def flagged_is_active?(params)
    params[:flagged].present?
  end

  def rsvp_is_active?(params)
    params[:rsvp].present?
  end

  def all_is_active?(params)
    !(params[:status].present? || params[:flagged].present?)
  end

  def editing_application?
    params[:action] == 'edit'
  end

  def admin_or_organizer?
    current_user.user_type == 'admin' || current_user.user_type == 'organizer'
  end

  def admin?
    current_user.user_type == 'admin'
  end


  def lack_permission_msg
    'Sorry, but you seem to lack the permission to go to that part of the website.'
  end
end