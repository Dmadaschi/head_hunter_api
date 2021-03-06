class V1::ApplicantProfilesController < ApplicationController
  before_action :authenticate_applicant!, only: [:create]

  def create
    @applicant_profile = ApplicantProfile.create!(applicant_profile_params)
    render json: @applicant_profile, status: :created
  end

  def update
    applicant_profile = ApplicantProfile.find(params[:id])
    applicant_profile.update!(applicant_profile_params)
    render json: @applicant_profile, status: :ok
  end

  private

  def applicant_profile_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(
      params, only: %i[name nickname birthdate
                       description formation experience]
    ).merge(applicant_id: current_applicant.id)
  end
end
