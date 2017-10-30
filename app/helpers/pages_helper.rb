module PagesHelper

	def is_home_active?
		controller?("pages") and action?("index")
	end

	def is_check_in_active?
		controller?("pages") and action?("check_in")
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
		controller?("mentoship_requests")
	end

	def has_access_to_all_applications?
		current_user.is_organizer? or current_user.is_admin?
	end

	def current_user_application
		event_application_path(current_user.event_application)
	end

	def has_access_to_hardware?
		# TODO: Uncoment this later
		# current_user.is_accepted?
		current_user.is_admin?
	end

	def has_access_to_mentorship
		current_user.is_admin? or current_user.is_mentor?
	end

	def has_access_to_admin?
		current_user.is_admin?
	end

	def has_access_to_check_in?
		current_user.is_organizer? or current_user.is_admin?
	end
	

	# Helper methonds to this helper class. lol so meta
	def controller?(target_controller)
		target_controller.include?(params[:controller])
	end

	def action?(target_action)
		target_action.include?(params[:action])
	end


end
