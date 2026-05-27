class Student < ApplicationRecord
  belongs_to :school
  belongs_to :school_class

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :surname, presence: true
end