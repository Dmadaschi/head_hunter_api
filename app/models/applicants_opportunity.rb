class ApplicantsOpportunity < ApplicationRecord
  belongs_to :applicant
  belongs_to :opportunity
end
