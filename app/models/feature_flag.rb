class FeatureFlag < ApplicationRecord
  validates_uniqueness_of :name
end
