class CustomRsvp < ApplicationRecord
  belongs_to :user

  validate :custom_field_validation

  private

  def custom_field_validation
    HackumassWeb::Application::RSVP_CUSTOM_FIELDS.each do |c|
      if c['required']
        if answers[c['name']] == nil or answers[c['name']] == '' or answers[c['name']].length == 0
          errors.add("missing_custom_field_#{c['name']}".to_sym, "Please fill out this field: #{c['label']}")
        end
      end
      if c['validate_regex'] and answers[c['name']] and answers[c['name']].length > 0
        r = Regexp.new c['validate_regex']
        if !r.match?(answers[c['name']])
          errors.add("regex_answers_#{c['name']}".to_sym, c['validate_error'] ? c['validate_error'] : "Invalid entry for field: #{c['label']}")
        end
      end
      if c['max_chars']
        if answers[c['name']] and answers[c['name']].length > c['max_chars']
          errors.add("too_long_answers_#{c['name']}".to_sym, "The value for '#{c['label']}' is too long! The maximum length is #{c['max_chars']} characters")
        end
      end
    end
  end

end
