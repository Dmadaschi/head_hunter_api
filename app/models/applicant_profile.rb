class ApplicantProfile < ApplicationRecord
  belongs_to :applicant
  validates :name, :nickname, :birthdate, :description, presence: true
end
