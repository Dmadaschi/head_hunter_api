class OpportunitySerializer < ActiveModel::Serializer
  belongs_to :head_hunter
  attributes :id, :title, :hirer, :requirements, :description, :location
end
