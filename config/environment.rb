# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# remove fields_with_error divs
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag.html_safe
end