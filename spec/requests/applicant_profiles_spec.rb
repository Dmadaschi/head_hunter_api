require 'rails_helper'

describe 'applicant' do
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

  context 'create profile' do
    it 'successfully' do
      headers = { accept: 'application/json' }.merge(applicant_token)
      params = { data: {
        attributes: attributes_for(:applicant_profile)
      } }

      post v1_applicant_profiles_path, params: params,
                                       headers: headers

      expect(response).to have_http_status(:created)
      expect(ApplicantProfile.all.count).to eq(1)
    end
    it 'and save prams' do
      headers = { accept: 'application/json' }.merge(applicant_token)
      params = {
        data: {
          attributes: {
            name: 'João da Silva',
            nickname: 'Jony',
            birthdate: '2005-01-12',
            formation: 'Publicidade e propaganda',
            experience: 'Gestor de midias 2019-Hoje',
            description: 'Proatividade e trabalho em equipe'
          }
        }
      }

      post v1_applicant_profiles_path, params: params,
                                       headers: headers
      applicant = ApplicantProfile.last
      expect(applicant.name).to eq('João da Silva')
      expect(applicant.nickname).to eq('Jony')
      expect(applicant.birthdate.strftime('%Y-%m-%d'))
        .to eq('2005-01-12')
      expect(applicant.formation).to eq('Publicidade e propaganda')
      expect(applicant.experience)
        .to eq('Gestor de midias 2019-Hoje')
      expect(applicant.description)
        .to eq('Proatividade e trabalho em equipe')
    end
    it 'with missing attributes' do
      headers = { accept: 'application/json' }.merge(applicant_token)
      params = {
        data: {
          attributes: {
            name: nil,
            nickname: nil,
            birthdate: nil,
            formation: 'Publicidade e propaganda',
            experience: 'Gestor de midias 2019-Hoje',
            description: nil
          }
        }
      }

      post v1_applicant_profiles_path, params: params,
                                       headers: headers

      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(ApplicantProfile.all.count).to eq(0)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to include("Name can't be blank")
      expect(response_body).to include("Nickname can't be blank")
      expect(response_body).to include("Birthdate can't be blank")
      expect(response_body).to include("Description can't be blank")
    end
  end

  context 'update profile' do
    it 'successfully' do
      headers = { accept: 'application/json' }.merge(applicant_token)
      applicant_profile = create(:applicant_profile,
                                 applicant: Applicant.last)
      params = { data: {
        attributes: attributes_for(:applicant_profile)
      } }

      patch v1_applicant_profile_path(applicant_profile),
            params: params, headers: headers

      expect(response).to have_http_status(:ok)
    end

    it 'and update attributes' do
      headers = { accept: 'application/json' }.merge(applicant_token)
      applicant_profile = create(:applicant_profile,
                                 applicant: Applicant.last,
                                 name: 'João da Silva',
                                 nickname: 'Jony',
                                 birthdate: '2005-01-12',
                                 formation: 'Publicidade e propaganda',
                                 experience: 'Gestor de midias 2019-Hoje',
                                 description: 'Proatividade e trabalho em equipe')
      params = {
        data: {
          attributes: {
            name: 'Marcelo Menezes',
            nickname: 'Marcelo Dev',
            birthdate: '1995-01-12',
            formation: 'Analise de sistemas',
            experience: 'Desenvolvedor Ruby on Rails',
            description: 'Desenvolvedor back-end'
          }
        }
      }

      patch v1_applicant_profile_path(applicant_profile),
            params: params, headers: headers
      applicant_profile.reload

      expect(applicant_profile.name).to eq('Marcelo Menezes')
      expect(applicant_profile.nickname).to eq('Marcelo Dev')
      expect(applicant_profile.birthdate.strftime('%Y-%m-%d'))
        .to eq('1995-01-12')
      expect(applicant_profile.formation)
        .to eq('Analise de sistemas')
      expect(applicant_profile.experience)
        .to eq('Desenvolvedor Ruby on Rails')
      expect(applicant_profile.description)
        .to eq('Desenvolvedor back-end')
    end

    it 'with no applicant profile' do
      headers = { accept: 'application/json' }.merge(applicant_token)
      applicant_profile = create(:applicant_profile,
                                 applicant: Applicant.last)
      params = { data: {
        attributes: attributes_for(:applicant_profile)
      } }

      patch v1_applicant_profile_path(0),
            params: params, headers: headers
      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_found)
      expect(response_body).to include("Couldn't find ApplicantProfile with 'id'=0")
    end

    it 'with invalid params' do
      headers = { accept: 'application/json' }.merge(applicant_token)
      applicant_profile = create(:applicant_profile,
                                 applicant: Applicant.last,
                                 name: 'João da Silva',
                                 nickname: 'Jony',
                                 birthdate: '2005-01-12',
                                 formation: 'Publicidade e propaganda',
                                 experience: 'Gestor de midias 2019-Hoje',
                                 description: 'Proatividade e trabalho em equipe')
      params = {
        data: {
          attributes: {
            name: nil,
            nickname: nil,
            birthdate: nil,
            formation: 'Analise de sistemas',
            experience: 'Desenvolvedor Ruby on Rails',
            description: nil
          }
        }
      }

      patch v1_applicant_profile_path(applicant_profile),
            params: params, headers: headers
      applicant_profile.reload
      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to include("Name can't be blank")
      expect(response_body).to include("Nickname can't be blank")
      expect(response_body).to include("Birthdate can't be blank")
      expect(response_body).to include("Description can't be blank")
      expect(applicant_profile.name).to eq('João da Silva')
      expect(applicant_profile.nickname).to eq('Jony')
      expect(applicant_profile.birthdate.strftime('%Y-%m-%d'))
        .to eq('2005-01-12')
      expect(applicant_profile.formation).to eq('Publicidade e propaganda')
      expect(applicant_profile.experience)
        .to eq('Gestor de midias 2019-Hoje')
      expect(applicant_profile.description)
        .to eq('Proatividade e trabalho em equipe')
    end
  end
end
