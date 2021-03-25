class Opportunity < ApplicationRecord
  belongs_to :head_hunter
  has_many :applicants_opportunities
  has_many :applicants, through: :applicants_opportunities

  validates :title, :hirer, :description, :requirements,
            :location, presence: true
end
