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
                :resume_file,
                :linkedin,
                :github,
                :programmer_type_list,
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

      # RESUME:
        has_attached_file :resume,
                          :storage => :s3,
                          :url => 's3.amazonaws.com',
                          :s3_credentials => {
                            :bucket => 'dev-hackumass-v-resume',
                            :access_key_id => 'AKIAI5CVP3FA7SBS5WPA',
                            :secret_access_key => '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',
                            :s3_region => 'us-east-1'

                          }

        validates_attachment :resume,
                             :content_type => {:content_type => ['application/pdf']},
                             :size => {:in => 0...1.megabytes}
                             
       def contains_name?
          temp = Paperclip.io_adapters.for(resume)
          file = File.open(temp.path)
          reader = PDF::Reader.new(file)
          return reader.page(1).text.include? name
        end
                              
       validates_attachment_presence :resume, 
                                     :if => :contains_name?

        
                                


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