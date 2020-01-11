class Judgement < ApplicationRecord
  has_one :user  # The person who has judged the project
  has_one :project  # The project associated with the judgement

  validates_presence_of :score
end
