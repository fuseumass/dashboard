class EventApplication < ApplicationRecord

  # give us elastic search functionality in event application
  # searchkick

  # creates a one to one association with the user
  belongs_to :user

  # checks to see that all the required fields are presence
  validates_presence_of %i[name university major],
                        message: 'Please enter %{attribute}. This field is required.'

  validates_presence_of %i[grad_year sex age t_shirt],
                        message: 'Please select your %{attribute}. This field is required.'

  validates_inclusion_of %i[food_restrictions transportation previous_hackathon_attendance],
                         in: [true, false],
                         message: 'Please pick an answer for \'%{attribute}\'. This field is required.'

  validates_presence_of %i[food_restrictions_info],
                        if: -> { food_restrictions? },
                        message: 'Please list your dietary restrictions and/or food allergies.'

  validates_presence_of %i[transportation_location],
                        if: -> { transportation? },
                        message: 'Please tell us where you need to be transport from.'

  validates_presence_of %i[waiver_liability_agreement],
                        message: 'Please agree to the Terms & Conditions.'

  # validation for phone field:
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

  # validation for linkedin field:
  # checks to see that the user put down a proper linkedin link
  validates_format_of %i[linkedin],
                      if: -> { linkedin.present? },
                      with: %r{\A(https:\/\/)?(www.)?linkedin.com\/in\/\S+\z},
                      message: 'Your Linkedin URL is invalid. Example format: https://linkedin.com/in/yourprofile'

  # validation for github field:
  # checks to see that the user put down a proper github link
  validates_format_of %i[github],
                      if: -> { github.present? },
                      with: %r{\A(https:\/\/)?(www.)?github.com\/\S+\z},
                      message: 'Your Github URL is invalid. Example format: https://github.com/yourgithub'

  # additional validation for name field:
  # checks to see that the user inputs a name that has more than 2 characters and
  # that the characters only contain letters, periods, dashes and apostrophes
  validates :name,
            if: -> { name.present? },
            length: { minimum: 2,
                      message: 'Name must be longer than %{count} characters.' },
            # The following regex below was taken from Kirill Polishchuk on stack overflow;
            # link to the post - https://goo.gl/pXPyN5.
            format: { if: -> { errors[:name].length.zero? },
                      with: /\A^[\p{L}\s'.-]+\z/,
                      message: 'Name can only contain letters, periods, dashes and apostrophes.' }

  # validation for all textbox inputs:
  # checks to see that all textbox answer (excluding the food restrictions textbox)
  # must be less than or equal to 500 characters long
  validates_length_of %i[how_did_you_hear_about_hackumass future_hardware_for_hackumass],
                      maximum: 500,
                      message: 'Your textbox answers must be less than %{count} characters long.'
end
