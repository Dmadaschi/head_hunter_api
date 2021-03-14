class ApplicantProfileSerializer < ActiveModel::Serializer
  belongs_to :applicant
  attributes :id, :name, :nickname, :birthdate,
             :description, :formation, :experience
end
