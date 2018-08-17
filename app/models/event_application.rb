class EventApplication < ApplicationRecord
  after_validation :remove_repeats_err_msg
  before_create :rename_file
  after_update :rename_file
  # after_create :submit_email

  # give us elastic search functionality in event application
  # searchkick

  # creates a one to one association with the user
  belongs_to :user

  # checks to see that all the required fields are presence
  validates_presence_of %i[name university major],
                        message: 'Please enter %{attribute}. This field is required.'

  validates_presence_of %i[sex age t_shirt_size],
                        message: 'Please select your %{attribute}. This field is required.'

  validates_presence_of %i[resume],
                        message: 'Please upload your resume. This field is required.'

  validates_inclusion_of %i[food_restrictions prev_attendance],
                         in: [true, false],
                         message: 'Please pick an answer for \'%{attribute}\'. This field is required.'

  validates_presence_of %i[food_restrictions_info],
                        if: -> { food_restrictions? },
                        message: 'Please list your dietary restrictions and/or food allergies.'

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
  validates_format_of %i[linkedin_url],
                      if: -> { linkedin_url.present? },
                      with: %r{\A(https:\/\/)?(www.)?linkedin.com\/in\/\S+\z},
                      message: 'Your Linkedin URL is invalid. Example format: https://linkedin.com/in/yourprofile'

  # validation for github field:
  # checks to see that the user put down a proper github link
  validates_format_of %i[github_url],
                      if: -> { github_url.present? },
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
  validates_length_of %i[referral_info future_hardware_suggestion],
                      maximum: 500,
                      message: 'Your textbox answers must be less than %{count} characters long.'

  # extra config for resume file
  has_attached_file :resume,
                    path: 'resume/:filename'

  # validates the resume attachments:
  # checks to see that the file is under 1.5MB and that the resume is a PDF
  validates_attachment :resume,
                       content_type: { content_type: 'application/pdf',
                                       message: 'Resume file must be a PDF.' },
                       size: { less_than: 2.megabyte,
                               message: 'Resume file must be under 2MB in size.' }

  # checks to see that the user resume is legit
  validate :resume_legitimacy,
           if: -> { resume.present? && errors[:resume].length.zero? }

  private

  def resume_legitimacy
    resume_path = Paperclip.io_adapters.for(self.resume).path
    resume = File.open(resume_path, 'rb')
    begin
      parser = PDF::Reader.new(resume).page(1).text.downcase!.tr!("\n", ' ').squeeze!(' ')
      if parser.length.positive? && parser.length < 400 || !resume_contains(name, parser)
        errors.add(:invalid_resume, 'Resume file is invalid. Please make
        sure that the file you have uploaded has all your actual information.
        Contact us at \'team@hackumass.com\' if you have any more problem
        uploading your resume.')
      end
      self.flag = !(resume_contains(university, parser) && resume_contains(major, parser))
    rescue
      errors.add(:invalid_resume, 'Resume file is invalid. Please make
        sure that the file is a OCR PDF. Contact us at \'team@hackumass.com\'
        if you have any more problem uploading your resume.')
    end
  end

  # checks to see if the resume file contains the given string
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
    errors.delete(:resume) if errors.key?(:resume)
  end

  # send email confirmation to user once they submit there application
  def submit_email
    UserMailer.submit_email(user).deliver_now
  end

end
