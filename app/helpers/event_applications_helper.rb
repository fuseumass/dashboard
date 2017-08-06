module EventApplicationsHelper

	def isDeniedActive(params)
		params[:status].present? and params[:status] == 'denied'
	end

	def isWaitlistedActive(params)
		params[:status].present? and params[:status] == 'waitlisted'
	end

	def isAcceptedActive(params)
		params[:status].present? and params[:status] == 'accepted'
	end

	def isUndecidedActive(params)
		params[:status].present? and params[:status] == 'undecided'
	end

	def isFlaggedActive(params)
		params[:flagged].present?
	end

	def isAllActive(params)
		!(params[:status].present? or params[:flagged].present?)
	end

	def is_editing_application
		params[:action] == 'edit'
	end

	def has_permissions_to_edit
		current_user.is_admin?
	end

	def is_admin_or_organizer?
		current_user.user_type == 'admin' or current_user.user_type == 'organizer'
	end
end