class V1::OpportunitiesController < ApplicationController
  before_action :authenticate_head_hunter!, only: [:create]
  def create
    @opportunity = Opportunity.create!(opportunity_params)
    render json: @opportunity, status: :created
  end

  private

  def opportunity_params
    params.require(:opportunity)
          .permit(:title, :hirer, :description,
                  :requirements, :location)
          .merge(head_hunter_id: current_head_hunter.id)
  end
end
