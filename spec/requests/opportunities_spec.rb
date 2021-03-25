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

    post applicant_session_path, params: params
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

    it 'successfully' do
      headers = { accept: 'application/json' }.merge(head_hunter_token)
      head_hunter = HeadHunter.find_by(email: headers.fetch(:uid))
      params = {
        data: {
          attributes: {
            title: 'titulo', hirer: 'Empresa',
            description: 'Opirtunidade blá blá blá',
            requirements: 'Ruby-on-rails, REST, React.js',
            location: 'Av Paulista'
          }
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
    it 'with invalid params' do
      headers = { accept: 'application/json' }.merge(head_hunter_token)
      params = { opportunity: { title: '', hirer: '', description: '',
                                requirements: '', location: '' } }

      post v1_opportunities_path, params: params, headers: headers

      response_json = JSON.parse(response.body)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_json).to include("Title can't be blank")
      expect(response_json).to include("Hirer can't be blank")
      expect(response_json).to include("Description can't be blank")
      expect(response_json).to include("Requirements can't be blank")
      expect(response_json).to include("Location can't be blank")
    end
  end

  context 'view opportunity' do
    it 'with no access_token' do
      headers = { accept: 'application/json' }
      opportunity = create(:opportunity)
      get v1_opportunity_path(opportunity), headers: headers
      expect(response).to have_http_status(:unauthorized)
    end

    it 'with applicant authentication' do
      headers = { accept: 'application/json' }.merge(applicant_token)
      opportunity = create(:opportunity)
      get v1_opportunity_path(opportunity), headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'with head hunter authentication' do
      headers = { accept: 'application/json' }.merge(head_hunter_token)
      opportunity = create(:opportunity)
      get v1_opportunity_path(opportunity), headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'successfully' do
      headers = { accept: 'application/json' }.merge(head_hunter_token)
      opportunity = create(:opportunity, title: 'title', hirer: 'hirer',
                                         description: 'description',
                                         requirements: 'requirements',
                                         location: 'location')

      get v1_opportunity_path(opportunity), headers: headers

      response_json = JSON.parse(response.body, symbolize_names: true).fetch(:data)
      expect(response_json.fetch(:id)).to eq(opportunity.id.to_s)
      expect(response_json.fetch(:type)).to eq('opportunities')
      expect(response_json.fetch(:attributes).fetch(:title)).to eq('title')
      expect(response_json.fetch(:attributes).fetch(:hirer)).to eq('hirer')
      expect(response_json.fetch(:attributes).fetch(:description)).to eq('description')
      expect(response_json.fetch(:attributes).fetch(:requirements)).to eq('requirements')
      expect(response_json.fetch(:attributes).fetch(:location)).to eq('location')
    end

    it 'with no opportunity' do
      headers = { accept: 'application/json' }.merge(head_hunter_token)
      Opportunity.destroy_all
      get v1_opportunity_path(1), headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'view multiple opportunities' do
    it 'with no authentication' do
      headers = { accept: 'application/json' }
      create_list(:opportunity, 5)
      get v1_opportunities_path, headers: headers
      expect(response).to have_http_status(:unauthorized)
    end

    it 'with applicant authentication' do
      headers = { accept: 'application/json' }.merge(applicant_token)
      create(:opportunity)
      get v1_opportunities_path, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'with head hunter authentication' do
      headers = { accept: 'application/json' }.merge(head_hunter_token)
      create(:opportunity)
      get v1_opportunities_path, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'successfully' do
      headers = { accept: 'application/json' }.merge(head_hunter_token)
      create_list(:opportunity, 5)
      params = {
        page: {
          number: 1,
          size: 5
        }
      }
      get v1_opportunities_path, params: params, headers: headers

      response_json = JSON.parse(response.body, symbolize_names: true)
                          .fetch(:data)
      expect(response_json.count).to eq(5)
      expect(response_json.first.fetch(:id)).to eq(Opportunity.first.id.to_s)
      expect(response_json[1].fetch(:id)).to eq(Opportunity.all[1].id.to_s)
      expect(response_json[2].fetch(:id)).to eq(Opportunity.all[2].id.to_s)
      expect(response_json[3].fetch(:id)).to eq(Opportunity.all[3].id.to_s)
      expect(response_json[4].fetch(:id)).to eq(Opportunity.all[4].id.to_s)
    end

    it 'just first page' do
      headers = { accept: 'application/json' }.merge(head_hunter_token)
      create_list(:opportunity, 5)
      params = {
        page: {
          number: 1,
          size: 3
        }
      }
      get v1_opportunities_path, params: params, headers: headers

      response_json = JSON.parse(response.body, symbolize_names: true)
                          .fetch(:data)
      expect(response_json.count).to eq(3)
      expect(response_json.first.fetch(:id)).to eq(Opportunity.first.id.to_s)
      expect(response_json[1].fetch(:id)).to eq(Opportunity.all[1].id.to_s)
      expect(response_json[2].fetch(:id)).to eq(Opportunity.all[2].id.to_s)
    end
    it 'just second page' do
      headers = { accept: 'application/json' }.merge(head_hunter_token)
      Opportunity.destroy_all
      create_list(:opportunity, 5)
      params = {
        page: {
          number: 2,
          size: 3
        }
      }
      get v1_opportunities_path, params: params, headers: headers

      response_json = JSON.parse(response.body, symbolize_names: true)
                          .fetch(:data)
      expect(response_json.count).to eq(2)
      expect(response_json[0].fetch(:id)).to eq(Opportunity.all[3].id.to_s)
      expect(response_json[1].fetch(:id)).to eq(Opportunity.all[4].id.to_s)
    end
  end

  context 'applicant apply to opportunity' do
    it 'successfully' do
      headers = { accept: 'application/json' }.merge(applicant_token)
      opportunity = create(:opportunity)
      applicant = Applicant.last
      create(:applicant_profile, applicant: applicant)
      params = { data: {
        attributes: { opportunity_id: opportunity.id }
      } }

      post apply_v1_opportunity_path(opportunity), params: params,
                                                   headers: headers

      opportunity.reload
      expect(response).to have_http_status(:created)
      expect(opportunity.applicants.count).to eq(1)
    end

    it 'with no applicant loged in' do
      headers = { accept: 'application/json' }.merge(head_hunter_token)
      opportunity = create(:opportunity)
      params = { data: {
        attributes: { opportunity_id: opportunity.id }
      } }

      post apply_v1_opportunity_path(opportunity), params: params,
                                                   headers: headers

      opportunity.reload
      expect(response).to have_http_status(:unauthorized)
      expect(opportunity.applicants.count).to eq(0)
    end

    it 'and save applicant' do
      headers = { accept: 'application/json' }.merge(applicant_token)
      opportunity = create(:opportunity)
      applicant = Applicant.last
      create(:applicant_profile, applicant: applicant)
      params = { data: {
        attributes: { opportunity_id: opportunity.id }
      } }

      post apply_v1_opportunity_path(opportunity), params: params,
                                                   headers: headers
      applicant.reload
      opportunity.reload
      expect(response).to have_http_status(:created)
      expect(opportunity.applicants.last).to eq(applicant)
      expect(applicant.opportunities.last).to eq(opportunity)
    end

    it 'and validates applicant profile presence' do
      headers = { accept: 'application/json' }.merge(applicant_token)
      opportunity = create(:opportunity)
      applicant = Applicant.last
      params = { data: {
        attributes: { opportunity_id: opportunity.id }
      } }

      post apply_v1_opportunity_path(opportunity), params: params,
                                                   headers: headers
      applicant.reload
      opportunity.reload
      response_json = JSON.parse(response.body, symbolize_names: true)
                          .fetch(:errors)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(opportunity.applicants.count).to eq(0)
      expect(applicant.opportunities.count).to eq(0)
      expect(response_json)
        .to include('applicant must have profile before apply to an oportunity')
    end
  end
end
