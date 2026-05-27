class School < ApplicationRecord
  has_many :school_classes, dependent: :destroy

  validates :name, presence: true
end