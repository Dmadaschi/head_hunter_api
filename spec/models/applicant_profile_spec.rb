require 'rails_helper'

RSpec.describe ApplicantProfile, type: :model do
  describe 'create applicant profile' do
    it 'successfully' do
      applicant = Applicant.create!(
        email: 'applicant@applicant.com',
        password: 'aaaaaaaaaaaa'
      )
      profile = ApplicantProfile.create(name: 'Daniel M',
                                        nickname: 'Daniel',
                                        birthdate: '1975-02-20',
                                        description: 'descrição',
                                        formation: 'Contabilidade',
                                        experience: 'Estágiario',
                                        applicant: applicant)
      expect(ApplicantProfile.last).to eq(profile)
      expect(profile.name).to eq('Daniel M')
      expect(profile.nickname).to eq('Daniel')
      expect(profile.birthdate.strftime('%Y-%m-%d')).to eq('1975-02-20')
      expect(profile.description).to eq('descrição')
      expect(profile.formation).to eq('Contabilidade')
      expect(profile.experience).to eq('Estágiario')
      expect(profile.applicant).to eq(applicant)
    end
    it 'validate attributes presence' do
      profile = build(:applicant_profile, name: nil, nickname: nil,
                                          birthdate: nil,
                                          description: nil)
      expect(profile.valid?).to be_falsey
      expect(profile.errors[:name]).to include("can't be blank")
      expect(profile.errors[:nickname]).to include("can't be blank")
      expect(profile.errors[:birthdate]).to include("can't be blank")
      expect(profile.errors[:description]).to include("can't be blank")
      expect(profile.errors[:applicant]).to include('must exist')
    end
  end
end
