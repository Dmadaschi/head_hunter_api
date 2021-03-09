require 'rails_helper'

describe 'opportunities' do
  let(:head_hunter_token) do
    params = { email: 'head_hunter@gmail.com',
               password: '12345678' }
    post head_hunter_registration_path,
         params: params.merge(password_confirmation: '12345678')


    post head_hunter_session_path, params: params

    { 'access-token': response.headers['access-token'],
      client: response.headers['client'],
      uid: response.headers['uid'] }
  end

  let(:applicant_token) do
    params = { email: 'applicant@gmail.com',
               password: '12345678' }
    post applicant_registration_path,
         params: params.merge(password_confirmation: '12345678')

    post :applicant_session_path, params: params
    { 'access-token': response.headers['access-token'],
      client: response.headers['client'],
      uid: response.headers['uid'] }
  end

  context 'request_create' do
    it 'with no access_token' do
      headers = { accept: 'application/json' }
      post v1_opportunities_path, params: {}, headers: headers
      expect(response).to have_http_status(:unauthorized)
    end
    it 'successfully' do
      headers = { accept: 'application/json' }.merge(head_hunter_token)
      post v1_opportunities_path, params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end
  end
end
