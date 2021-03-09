class V1::OpportunitiesController < ApplicationController
  before_action :authenticate_head_hunter!, only: [:create]
  before_action :authenticate_member!, only: [:show]

  def create
    @opportunity = Opportunity.create!(opportunity_params)
    render json: @opportunity, status: :created
  end

  def show
    @opportunity = Opportunity.find(params[:id])
    render json: @opportunity
  end

  private

  def opportunity_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(
      params, only: %i[title hirer description requirements location]
    ).merge(head_hunter_id: current_head_hunter.id)
  end
end
