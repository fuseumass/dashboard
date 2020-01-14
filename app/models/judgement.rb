class Judgement < ApplicationRecord

  belongs_to :project
  belongs_to :user

  validates :project_id, uniqueness: true
  validates :user_id, presence: true

end
