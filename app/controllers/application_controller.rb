class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  devise_token_auth_group :member, contains: %i[applicant head_hunter]

  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  private

  def record_invalid(exception)
    render json: exception.record.errors.full_messages,
           status: :unprocessable_entity
  end
end
