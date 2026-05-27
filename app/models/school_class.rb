class SchoolClass < ApplicationRecord
  belongs_to :school

  has_many :students, dependent: :destroy

  validates :number, presence: true
  validates :letter, presence: true
end