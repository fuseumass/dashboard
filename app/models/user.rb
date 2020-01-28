class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates_presence_of :first_name, :last_name
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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
    if self.slack_id != nil
      return true
    else
      return false
    end
  end

  def get_slack_id
    return self.slack_id
  end


end
