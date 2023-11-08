class EventApplication < ApplicationRecord
  after_validation :remove_repeats_err_msg
  before_create :rename_file
  before_update :rename_file
  after_create :submit_email

  def min_resume_age
    HackumassWeb::Application::EVENT_APPLICATION_OPTIONS['min_resume_age'] or 0
  end

  # creates a one to one association with the user.
  belongs_to :user

  # checks to see that all the required fields are present.
  validates_presence_of %i[name university major],
                        message: 'Please enter %{attribute}. This field is required.'

  validates_presence_of %i[gender age t_shirt_size education_lvl],
                        message: 'Please select your %{attribute}. This field is required.'

  # Added 'false and' to make resumes optional. 
  # validates_presence_of %i[resume],
  #                       message: 'Please upload your resume. This field is required.',
  #                       if: -> { false and age.to_i > min_resume_age() and !Rails.env.development?}

  validates_inclusion_of %i[food_restrictions],
                         in: [true, false],
                         message: 'Please pick an answer for \'%{attribute}\'. This field is required.'

  validates_presence_of %i[food_restrictions_info],
                        if: -> { food_restrictions? },
                        message: 'Please list your dietary restrictions and/or food allergies.'

  validates_presence_of %i[waiver_liability_agreement],
                        if: -> { !HackumassWeb::Application::EVENT_APPLICATION_OPTIONS['hide_event_toc'] },
                        message: 'Please agree to the Terms & Conditions.'

  validates_presence_of %i[mlh_agreement],
                        if: -> { !HackumassWeb::Application::EVENT_APPLICATION_OPTIONS['hide_mlh_toc'] },
                        message: 'Please agree to the MLH Terms & Conditions.'

  # checks to see that the user put down a valid phone number

  validates :phone,
            allow_blank: true,
            if: -> { phone.present? },
            format: { with: /\A\(\d{3}\)\s\d{3}-\d{4}\z|\A[0-9]+\z/,
                      message: 'Your phone number is invalid. Should only contain numbers.' },
            length: { if: -> { errors[:phone].length.zero? },
                      minimum: 10,
                      maximum: 14,
                      message: 'Your phone number must be 10 digits long.' }
  # checks that gender is valid
  validates :gender,
            if: -> {gender.present? },
            inclusion: { in: %w(Female Male Non-Binary Other No-Answer),
            message: "%{value} is not a valid gender." }
  # checks to see that the user inputs a name that has more than 2 characters and
  # that the characters only contain letters, periods, dashes and apostrophes.
  validates :name,
            if: -> { name.present? },
            length: { minimum: 2,
                      message: 'Name must be longer than %{count} characters.' },
            # The following regex below was taken from Kirill Polishchuk on stack overflow;
            # link to the post - https://goo.gl/pXPyN5.
            format: { if: -> { errors[:name].length.zero? },
                      with: /\A^[\p{L}\s'.-]+\z/,
                      message: 'Name can only contain letters, periods, dashes and apostrophes.' }

  # extra config for resume file.
  has_attached_file :resume,
                    path: 'resume/:filename'

  # checks to see that the file is under 1.5MB and that the resume is a PDF.
  validates_attachment :resume,
                       content_type: { content_type: 'application/pdf',
                                       message: 'Resume file must be a PDF.' },
                       size: { less_than: 2.megabyte,
                               message: 'Resume file must be under 2MB in size.' },
                        if: -> { resume.present? }

  # checks to see that the user resume is legit.
  validate :resume_legitimacy,
           if: -> { !Rails.env.development? && resume.present? && errors[:resume].length.zero? || errors[:resume].to_s.include?('contents') }
  
  validate :custom_field_validation

  private

  def custom_field_validation
    HackumassWeb::Application::EVENT_APPLICATION_CUSTOM_FIELDS.each do |c|
      if c['required']
        if custom_fields[c['name']] == nil or custom_fields[c['name']] == '' or custom_fields[c['name']].length == 0
          errors.add("missing_custom_field_#{c['name']}".to_sym, "Please fill out this field: #{c['label']}")
        end
      end
      if c['validate_regex'] and custom_fields[c['name']] and custom_fields[c['name']].length > 0
        r = Regexp.new c['validate_regex']
        if !r.match?(custom_fields[c['name']])
          errors.add("regex_custom_fields_#{c['name']}".to_sym, c['validate_error'] ? c['validate_error'] : "Invalid entry for field: #{c['label']}")
        end
      end
      if c['max_chars']
        if custom_fields[c['name']] and custom_fields[c['name']].length > c['max_chars']
          errors.add("too_long_custom_fields_#{c['name']}".to_sym, "The value for '#{c['label']}' is too long! The maximum length is #{c['max_chars']} characters")
        end
      end
    end
  end

  def resume_legitimacy
    if age.to_i > min_resume_age() and !Rails.env.development?
      resume_path = Paperclip.io_adapters.for(self.resume).path
      resume = File.open(resume_path, 'rb')
      begin
        parser = PDF::Reader.new(resume).page(1).text.downcase!.tr!("\n", ' ').squeeze!(' ')
        self.flag = parser.length < 400 || !resume_contains(name, parser) || !(resume_contains(university, parser) || !resume_contains(major, parser))
      rescue
        self.flag = true
      end
    end
  end

  # checks to see if the resume file contains the given string.
  def resume_contains(string, resume_file)
    string.downcase!
    return true if resume_file.include?(string.delete(' '))
    return true if resume_file.include?(string)
    string_array = string.split(' ')
    string_array.each do |part|
      return true if resume_file.include?(part)
    end
    false
  end

  # This method when executed will rename the resume file that the
  # applicant has upload to the format, user id follow by his or her first
  # name and then his or her last name follow by the .pdf extension.
  # (eg. 1_JohnSmith.pdf )
  def rename_file
    new_file_name = "#{user_id}_#{user.first_name}_#{user.last_name}"
    resume.instance_write :file_name, new_file_name + '.pdf'
  end

  # Because of how paperclips works, when validating it will create
  # two identical error that are link to different symbols. This
  # method will remove one of the symbol there by removing the
  # duplication.
  def remove_repeats_err_msg
    presence_msg = 'Please upload your resume. This field is required.'
    errors.delete(:resume) if errors[:resume].length > 0 && !errors[:resume].include?(presence_msg)
  end

  # send email confirmation to user once they submit there application.
  def submit_email
    UserMailer.submit_email(user).deliver_now
  end


  


  # Generating CSV for all Event Applications
	def self.to_csv
		CSV.generate do |csv|
      csv_header = Array.new    
      custom_fields = HackumassWeb::Application::EVENT_APPLICATION_CUSTOM_FIELDS.map { |i| i['name'] }
      event_fields = EventApplication.column_names
      event_fields.delete("resume_content_type")
      event_fields.delete("resume_file_size")
      event_fields.delete("resume_updated_at")
      
      user_fields = ["first_name", "last_name", "email", "rsvp", "check_in"]

      for value in user_fields
        csv_header.push(value)
      end
    
      for value in event_fields
        if value != 'custom_fields'
          csv_header.push(value)
        end
      end

      for value in custom_fields
        csv_header.push(value)
      end

      csv << csv_header

			EventApplication.find_each do |app|
        arr = Array.new
        arr = app.attributes.values
        finalArr = Array.new

        for value in user_fields
          finalArr.push(app.user[value])
        end

        for value in event_fields
          if value != 'custom_fields'
            finalArr.push(app[value])  
          end
        end
        
        for value in custom_fields
          finalArr.push(app['custom_fields'][value])
        end
        csv << finalArr

		  	end
    end

  end
  
end

