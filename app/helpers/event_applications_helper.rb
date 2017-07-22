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

end