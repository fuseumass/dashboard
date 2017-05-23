class EventApplication < ApplicationRecord
    validates_presence_of :name, :university, :major, :grad_year, :email, :t_shirt
    validates :name, length: { minimum: 2 }
    validates :university, :major, format: {with: /\D/}
    validates :t_shirt, :sex, format: {with: /\S/, message: "can't be blank"}
    validates :phone, format: {with: /\d/}, length: {is: 10}, allow_blank: true
    validates :email, format: { with: /(\S)+@(\S)+\.(\S)+/ }
    validates :linkedin, format: {with: /((\S)+.linkedin.(\S)+)/, message: "URL is invalid"}, allow_blank: true
    validates :github, format: {with: /((\S)+github.(\S)+)/, message: "URL is invalid"}, allow_blank: true
    validates :waiver_liability_agreement, inclusion: [true]
    validates :are_you_interested_in_hardware_hacks, :do_you_have_a_team, :transportation, :previous_hackathon_attendance, :food_restrictions, inclusion: [true, false]
    belongs_to :user
end
