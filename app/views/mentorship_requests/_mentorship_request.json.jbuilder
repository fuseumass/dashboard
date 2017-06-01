json.extract! mentorship_request, :id, :user_id, :mentor_id, :title, :help_type, :status, :urgency, :created_at, :updated_at
json.url mentorship_request_url(mentorship_request, format: :json)
