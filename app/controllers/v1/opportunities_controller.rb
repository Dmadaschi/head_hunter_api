class V1::OpportunitiesController < ApplicationController
  before_action :authenticate_head_hunter!, only: [:create]
  before_action :authenticate_member!, only: %i[show index apply]
  before_action :authenticate_applicant!, only: %i[apply]
  before_action :set_opportunity, only: %i[show apply]

  def create
    @opportunity = Opportunity.create!(opportunity_params)
    render json: @opportunity, status: :created
  end

  def show
    render json: @opportunity
  end

  def index
    @opportunities = Opportunity.all.page(params[:page].try(:[], :number))
                                .per(params[:page].try(:[], :size))
    render json: @opportunities, status: :ok
  end

  def apply
    return missing_profile if current_applicant.applicant_profile.blank?

    @opportunity.applicants.push(current_applicant)
    render json: @opportunity, status: :created
  end

  private

  def missing_profile
    render json: {
      errors: ['Applicant must have profile before apply to an oportunity']
    }, status: :unprocessable_entity
  end

  def set_opportunity
    @opportunity = Opportunity.find(params[:id])
  end

  def opportunity_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(
      params, only: %i[title hirer description requirements location]
    ).merge(head_hunter_id: current_head_hunter.id)
  end
end
