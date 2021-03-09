require 'rails_helper'

RSpec.describe Opportunity, type: :model do
  describe 'create opportunity' do
    it 'successfully' do
      head_hunter = HeadHunter.create(email: 'head_hunter@gmail.com',
                                      password: 'aaaaaaaaaaaaaaaaaaaa')

      opportunity = Opportunity.create(head_hunter_id: head_hunter.id,
                                       title: 'titulo', hirer: 'Empresa',
                                       description: 'descrição',
                                       requirements: 'Ruby-on-rails',
                                       location: 'Av Paulista')
      expect(opportunity.valid?).to be_truthy
      expect(Opportunity.find(opportunity.id)).to eq(opportunity)
    end
    it 'validates presence' do
      opportunity = Opportunity.new
      expect(opportunity.valid?).to be_falsey
      expect(opportunity.errors[:head_hunter]).to include('must exist')
      expect(opportunity.errors[:title]).to include("can't be blank")
      expect(opportunity.errors[:hirer]).to include("can't be blank")
      expect(opportunity.errors[:description]).to include("can't be blank")
      expect(opportunity.errors[:requirements]).to include("can't be blank")
      expect(opportunity.errors[:location]).to include("can't be blank")
    end
  end
end
