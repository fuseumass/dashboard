class EventApplication < ApplicationRecord
  # link event_application to user:
    belongs_to :user

  # validation section for the required fields:

    # see if all the required fill-in / checkbox / drop-list fields are not blank:
      validates_presence_of :name,
                            :email,
                            :age,
                            :sex,
                            :university,
                            :major,
                            :grad_year,
                            :t_shirt,
                            :resume,
                            :waiver_liability_agreement

    # checks to see that all radio button fields are not blank:
      validates_inclusion_of :food_restrictions,
                             :transportation,
                             :previous_hackathon_attendance,
                             :in => [true, false]

    # additional validation for the field....

      # NAME:
        validates :name,
                  # only if name is fill-in will the following validation be checked
                  :if => 'name.present?',
                  # the length name has to be at least 2 character long
                  :length => {:minimum => 2},
                  # name must only contains letters and spaces
                  :format => {:with => /\A[A-Za-z\s]+\z/}

      # EMAIL:
        validates :email,
                  # only if email is fill-in will the following validation be checked
                  :if => 'email.present?',
                  # email contains only word character (e.g letters, numbers,
                  # and underscores) and follows the natural formatting of emails
                  :format => {:with => /\A(\S)+@(\S)+\.(\S)+\z/}


      # FOOD_RESTRICTIONS:
        validates :food_restrictions_info,
                  # only if food_restrictions is checked 'Yes' will the following
                  # validation be checked
                  :if => 'food_restrictions?',
                  # checks if the food_restrictions_info is fill-in
                  :presence => true

      # RESUME:
        has_attached_file :resume,
                          :storage => :s3,
                          :url => 's3.amazonaws.com',
                          :s3_credentials => {
                            :bucket => 'hackumass-v-resumes',
                            :access_key_id => 'AKIAJXQREHQP2AIJXVFQ',
                            :secret_access_key => '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',
                            :s3_region => 'us-east-1'
                          }

        validates_attachment :resume,

                             #( is it possible if we can remove the content type check because my code now covers for it and the error message seemed repetitive... Sorry Dan!) 
                             :content_type => {:content_type => ['application/pdf']},
                             :size => {:in => 0...1.megabytes}

        validate  :contains_name,
                  :if => 'resume.present?'

        private
          def contains_name
            temp = Paperclip.io_adapters.for(resume)
            file = File.open(temp.path, "rb")
            if File.extname(file) == ".pdf"
              reader = PDF::Reader.new(file)
              pdf = reader.page(1).text.downcase
              if pdf.include? (self.user.first_name.downcase) or pdf.include? (self.user.last_name.downcase) or pdf.include? (grad_year) or pdf.include? (email) or pdf.include? (sex)
              else 
               errors.add(:base, 'Sorry but it seems like your resume is not properly formatted. Make sure it is a PDF that has all your actual information, including the same full name (preferably without middle name/initial), email, sex, and/or year of graduation that you put in the application above. If your Resume is formatted properly and you still see this message, please contact us at team@hackumass.com')

              end
            else
             # errors.add(:base, 'Sorry but it seems like your resume is not a .pdf file. Please follow instructions and convert to a pdf.')
            end
            
          end

      # TRANSPORTATION:
        validates :transportation_location,
                  # only if transportation is checked 'Yes' will the following
                  # validation be checked
                  :if => 'transportation?',
                  # checks if the transportation_location is fill-in
                  :presence => true



  # validation section for the optional fields:

    # allows all the optional fields to be blank
      validates :phone,
                :linkedin,
                :github,
                :programmer_skills_list,
                :interested_in_hardware_hacks,
                :how_did_you_hear_about_hackumass,
                :future_hardware_for_hackumass,
                :presence => false

    # DISCLAIMER: food_restriction_info is purposely left out for this validation
    # because we don't want any health liability because an applicant could not write
    # down all his dietary restriction or allegry.
    #
    # limits text box field to 500 characters which translates to about roughly
    # 80-100 words (don't quote me on this though).
      validates_length_of :how_did_you_hear_about_hackumass,
                          :future_hardware_for_hackumass,
                          :maximum => 500

    # additional validation for the field...

      # PHONE:
        validates :phone,
                  # only if the phone number is fill-in will the following validation
                  # be checked
                  :if => 'phone.present?',
                  # phone number must be 10 digits long
                  :length => {:is => 10},
                  # phone number only contains digits
                  :format => {:with => /\d/}

      # LINKEDIN:
        validates :linkedin,
                  # only if the linkedin URL is fill-in will the following validation
                  # be checked
                  :if => 'linkedin.present?',
                  # linkedin url must start off with 'www.linkedin.com\in\' and
                  # can end with any combination of word character (e.g letters,
                  # numbers, and underscores) (e.g. www.linkedin.com\in\naruto)
                  :format => {:with => /\Awww.linkedin.com\/in\/(\w)+\z/}

      # GITHUB:
        validates :github,
                  # only if github URL is fill-in will the following validation be
                  # checked
                  :if => 'github.present?',
                  # github url must contains github.com and can start or end with
                  # any combination of word character (e.g letters,
                  # numbers, and underscores) (e.g. https:\\github.com\naruto)
                  :format => {:with => /\A(\S)+github.com\/(\w)+\z/}

      # INTERESTED_IN_HARDWARE_HACKS:
        validates :interested_hardware_hacks_list,
                  # only if interested_in_hardware_hacks is checked 'Yes' will the
                  # following validation be checked
                  :if => 'interested_in_hardware_hacks?',
                  # checks if the interested_hardware_hacks_list is not empty
                  :presence => true
end
