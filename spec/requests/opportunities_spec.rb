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

  context 'create opportunity' do
    it 'with no access_token' do
      headers = { accept: 'application/json' }
      post v1_opportunities_path, params: {}, headers: headers
      expect(response).to have_http_status(:unauthorized)
    end

    it 'and create opportuniite' do
      headers = { accept: 'application/json' }.merge(head_hunter_token)
      head_hunter = HeadHunter.find_by(email: headers.fetch(:uid))
      params = {
        opportunity: {
          title: 'titulo', hirer: 'Empresa',
          description: 'Opirtunidade blá blá blá',
          requirements: 'Ruby-on-rails, REST, React.js',
          location: 'Av Paulista', head_hunter: head_hunter
        }
      }

      post v1_opportunities_path, params: params, headers: headers
      opportunity = Opportunity.last

      expect(response).to have_http_status(:created)
      expect(opportunity.title).to eq('titulo')
      expect(opportunity.hirer).to eq('Empresa')
      expect(opportunity.description).to eq('Opirtunidade blá blá blá')
      expect(opportunity.requirements).to eq('Ruby-on-rails, REST, React.js')
      expect(opportunity.location).to eq('Av Paulista')
      expect(opportunity.head_hunter).to eq(head_hunter)
    end
  end
end
