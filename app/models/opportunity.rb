class Opportunity < ApplicationRecord
  belongs_to :head_hunter
  validates :title, :hirer, :description, :requirements,
            :location, presence: true
end
