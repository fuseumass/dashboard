json.extract! mentorship_request, :id, :user_id, :mentor_id, :title, :type, :status, :created_at, :updated_at
json.url mentorship_request_url(mentorship_request, format: :json)
