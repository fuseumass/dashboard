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

	def isAllActive(params)
		!params[:status].present?
	end

end