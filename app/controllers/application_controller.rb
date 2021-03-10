class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  devise_token_auth_group :member, contains: %i[applicant head_hunter]

  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_invalid(exception)
    render json: exception.record.errors.full_messages,
           status: :unprocessable_entity
  end

  def record_not_found(exception)
    render json: exception, status: :not_found
  end
end
