class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  if !Rails.env.development?
    validates :first_name, :last_name, presence: true, format: { with: /\A[a-zA-Z .'-]+\Z/, message: 'only allows letters, periods, apostrophes, hyphens and spaces' } 
  else
    validates :first_name, :last_name, presence: true
  end
  # Confirm that the email is not disposable or missing an MX record, and they agree to be emailed
  validates :email, presence: true,  'valid_email_2/email': {mx: true, disposable: true}



  if !Rails.env.development? && HackumassWeb::Application::EMAIL_VERIFICATION
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable
  else 
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable
  end
 
  include DeviseTokenAuth::Concerns::User

  has_many :hardware_checkouts, dependent: :destroy
  has_many :hardware_items, through: :hardware_checkouts
  has_one :event_application, dependent: :destroy
  has_many :mentorship_request, dependent: :destroy
  belongs_to :project, optional: true
  has_many :event_attendances
  has_many :events, through: :event_attendances
  has_many :judgements
  has_many :judging_assignments

  after_create :welcome_email

  # needed for slack integration
  require "net/http"
  require "uri"

  # slack workspace token for your hackathon
  $workspace_token = "#{HackumassWeb::Application::SLACK_WORKSPACE_TOKEN}"

  # Use type checkers
  def is_attendee?
  	user_type == 'attendee'
  end

  def is_admin?
  	user_type == 'admin'
  end

  def is_mentor?
  	user_type == 'mentor'
  end

  def rsvp?
  	user.rsvp == true
  end

  #Admins should have the same permissions (and more) that organizers do
  def is_organizer?
    user_type == 'organizer' or user_type == 'admin'
  end

  def is_host_student?
    if user_type != 'attendee'
      return false
    end
    if email.include?(HackumassWeb::Application::CHECKIN_UNIVERSITY_EMAIL_SUFFIX)
      return true
    end
    if not has_applied?
      return false
    end
    u = self.event_application.university.downcase
    HackumassWeb::Application::CHECKIN_UNIVERSITY_NAME_CHECKS.each do |name|
      if u.include? name.downcase
        return true
      end
    end
    return false
  end

  def full_name
    names = []
    names << first_name if first_name
    names << last_name if last_name
    names.join ' '
  end

  def has_applied?
    self.event_application.present?
  end

  def has_published_project?
    self.project.present?
  end

  def has_mentorship_requests?
    self.mentorship_request.present?
  end

  def number_of_requests
    self.mentorship_request.where(status: 'Waiting').count + self.mentorship_request.where(status: 'Contacted').count
  end

  def valid_requests
    self.mentorship_request.where(status: 'Waiting') + self.mentorship_request.where(status: 'Contacted')
  end

  def is_accepted?
    if has_applied?
      self.event_application.status == 'accepted'
    end
  end

  def welcome_email
    UserMailer.welcome_email(self).deliver_now
  end

  def has_slack?
    if !HackumassWeb::Application::SLACK_ENABLED || self.slack_id != nil
      return true
    else
      return false
    end
  end

  def get_slack_id
    if !HackumassWeb::Application::SLACK_ENABLED
      return -1
    end
    
    return self.slack_id
  end

  def get_slack_message_link
    if !HackumassWeb::Application::SLACK_ENABLED
      return ""
    end

    return "https://" + HackumassWeb::Application::SLACK_SUBDOMAIN + ".slack.com/team/" + self.slack_id
  end


end
