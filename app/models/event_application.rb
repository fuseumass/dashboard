class EventApplication < ApplicationRecord
  # ASSOCIATION:
    # Links event_application to user:
    belongs_to :user

  # ACTIVE RECORD CALLBACK:
    # Methods that get called after validation is completed:
    after_validation :remove_resume_repeat, :remove_empty_error

    # Because of how paperclips works, when validating for the size of the
    # resume, it will create two identical error that are link to different
    # symbols. This method will remove one of the symbol there by removing
    # the duplication.
    private
      def remove_resume_repeat
        if errors.keys.include?(:resume_file_size)
          errors.delete(:resume_file_size)
        end
      end

    # This method removes the empty error that occur when some variables passes
    # all its validation.
    private
      def remove_empty_error
        if errors[:phone].to_s.gsub(/[\[\]"\s]/, '') == ''
          errors.delete(:phone)
        end
        if errors[:name].to_s.gsub(/[\[\]"\s]/, '') == ''
          errors.delete(:name)
        end
      end

    # Methods that get called before the application is created:
    before_create :rename_resume_file

    # This method when executed will rename the resume file that the
    # applicant has upload to the format, user id follow by his or her first
    # name and then his or her last name follow by the .pdf extension.
    # (eg. 1_JohnSmith.pdf )
    private
      def rename_resume_file
        extension = File.extname(resume_file_name).downcase
        new_name = "#{user_id}_#{self.user.first_name}_#{self.user.last_name}"
        self.resume.instance_write :file_name, new_name + "#{extension}"
      end

    # Methods that get called after the application is created:
    after_create :submit_email

    # This method's sole purpose is to call the mailer method 'submit_email',
    # which sends an email to the applicant telling him or her that he or she
    # has successful created his or her application.
    private
      def submit_email
        UserMailer.submit_email(self.user).deliver_now
      end

  # VALIDATION FOR ALL THE REQUIRED FIELDS:
    # Checks to see if all the required fields are present:
    validates_presence_of :name,
                          :email,
                          :university,
                          :major,
                          message: 'Please enter your %{attribute}. This field
                          is required.'

    validates_presence_of :grad_year,
                          :sex,
                          :age,
                          :t_shirt,
                          message: 'Please select your %{attribute}. This field
                          is required.'

    validates_presence_of :resume,
                          message: 'Please upload your resume. This field is
                          required.'

    validates_inclusion_of :food_restrictions,
                           :transportation,
                           :previous_hackathon_attendance,
                           in: [true, false],
                           message: 'Please select an answer for
                           \'%{attribute}\'. This field is required.'

    validates_presence_of :waiver_liability_agreement,
                          message: 'Please agree to the Terms & Conditions.'

    # Additional validation for the field...
      # NAME:
        # Once after name has been filled in, check to see that length of name
        # is at least 2 and that it is formatted correctly.
        validates :name,
                  if: 'name.present?',
                  length: {
                    minimum: 2,
                    message: 'Name must be longer than %{count}
                    characters.'
                  },
                  # The following regex below was taken from Kirill Polishchuk
                  # on stack overflow; link to the post - https://goo.gl/pXPyN5.
                  format: {
                    if: 'errors[:name].length == 0',
                    with: /\A^[\p{L}\s'.-]+\z/,
                    message: 'Name should only contain letters, periods, dashes
                    and apostrophes.'
                  }

      # EMAIL:
        # Once after email has been filled in, check that it has been formatted
        # correctly.
        validates :email,
                  if: 'email.present?',
                  # The following regex below was taken from Mike H-R on
                  # stack overflow; link to the post - https://goo.gl/EorTih.
                  format: {
                    with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i,
                    message: 'Email format is invalid. Should follow this
                    format: email@example.com'
                  }

      # FOOD RESTRICTIONS:
        # If the applicant has answered 'yes' for the food restrictions field,
        # check to make sure that the food restriction text box is filled in.
        validates_presence_of :food_restrictions_info,
                              if: 'food_restrictions?',
                              message: 'Please list down your dietary
                              restrictions and or food allergies.'
      # RESUME FILE:
        # This paperclip method maps all the neccessary information needed for
        # uploading the resume file to AWS S3 storage.
        has_attached_file :resume,
                          storage: :s3,
                          s3_protocol: 'https',
                          path: ':filename',
                          s3_credentials: {
                            :bucket => 'hackumass-v-resumes',
                            :access_key_id => 'AKIAJXQREHQP2AIJXVFQ',
                            :secret_access_key => '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',
                            :s3_region => 'us-east-1'
                          }

        # Once the applicant upload a resume, call 'contains_name'.
        validate  :contains_string,
                  :if => 'resume.present?'

        # Remove the 'content_type' validation that is by default require when
        # using paperclip.
        do_not_validate_attachment_file_type :resume

        # Checks to see that the resume is under 1MB in size.
        validates_attachment_size :resume,
                                  in: 0...2.megabytes,
                                  message: 'Resume file must be at most 2MB
                                  in size.'

        # This method checks to see that resume file has a .pdf extension and if
        # it does, will go on to validate if the resume is invalid or valid.
        # A valid resume will contain the applicant name otherwise the resume
        # is considered invalid.
        private
          def contains_string
            temp = Paperclip.io_adapters.for(resume)
            file = File.open(temp.path, "rb")
            if File.extname(file) == ".pdf"
              reader = PDF::Reader.new(file)
              pdf = reader.page(1).text.downcase
              unless check_string?(pdf, name)||check_string?(pdf, email)||check_string?(pdf, university)||check_string?(pdf, major)
                errors.add(:resume_error, 'Resume file is invalid. Please make 
                sure that the file you have uploaded has all your actual 
                information. Please contact us at \'team@hackumass.com\' if you 
                have any problem uploading your resume.')
              end
            else
              errors.add(:extension_error, 'Resume file must be a pdf.')
            end
          end
      
        private
          def check_string?(pdf, string)
            string_no_space = string.gsub(' ', '')
            no_space_string_check = pdf.include?(string_no_space.downcase)
            string_check = pdf.include?(string.downcase)
            if string_check||no_space_string_check
              return true
            else
              stringArray = string.downcase.split(' ')
              stringArray.each do |part_of_string|
                if !pdf.include?(part_of_string)
                  return false
                end
              end
              return true
            end
          end

      # TRANSPORTATION:
        # if the applicant answers 'yes' for the transportation field, check to
        # see that the address textfield is not blank
        validates_presence_of :transportation_location,
                              if: 'transportation?',
                              message: 'Please tell us where you need to be
                              transport from.'

  # VALIDATION FOR ALL THE OPTIONAL FIELDS:
    # Checks to see that all the textbox field except the food restriction text
    # box don't exceed pass 500 characters
    validates_length_of :how_did_you_hear_about_hackumass,
                        :future_hardware_for_hackumass,
                        maximum: 500,
                        message: 'Your answer for \'%{attribute}\' must be less
                        than %{count} characters.'

    # additional validation for the field....
      # PHONE:
        # Once after phone has been filled in, check to see that it has length
        # of exactly 10 and it only contains digits
        validates :phone,
                  if: 'phone.present?',
                  allow_blank: true,
                  format: {
                    with: /\A\(\d{3}\)\s\d{3}-\d{4}\z|\A[0-9]+\z/,
                    message: 'Your phone number is invalid. Should only contain
                    numbers.'
                  },
                  length: {
                    if: 'errors[:phone].length == 0',
                    is: 14,
                    message: 'Your phone number must be 10 digits long.'
                  }

      # LINKEDIN:
        # Once after the applicant fills in the linkedin url, check to see that
        # it is formatted properly
        validates_format_of :linkedin,
                            if: 'linkedin.present?',
                            with: /\A(https:\/\/)?(www.)?linkedin.com\/in\/\S+\z/,
                            message: 'Your linkedin URL is invalid. Should follow
                            this format: https://linkedin.com/in/yourprofile.'

      # GITHUB:
        # Once after the applicant fills in the github url, check to see that it
        # is formatted properly
        validates_format_of :github,
                            if: 'github.present?',
                            with: /\A(https:\/\/)?(www.)?github.com\/\S+\z/,
                            message: 'Your github URL is invalid. Should follow
                            this format: https://github.com/yourgithub.'

      # INTERESTED IN HARDWARE HACKS:
        # If the applicant answers 'yes' for the interested in hardware hacks
        # field, check to see if he or she also has checked the type of hardware
        # hacks he or she is interested in.
        validate :interested_hardware_hacks_list_error,
                 if: 'interested_in_hardware_hacks?'

        private
        def interested_hardware_hacks_list_error
          if interested_hardware_hacks_list == '{}'
            message = 'Please select at least one hardware hack you are
            interested in.'
            errors.add(:check_box_error, message)
          end
        end
end
