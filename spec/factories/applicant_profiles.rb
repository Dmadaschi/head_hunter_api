FactoryBot.define do
  factory :applicant_profile do
    name { 'Daniel Madaschi' }
    nickname { 'DMadaschi' }
    birthdate { '1997-03-18' }
    formation { 'Software Engenere' }
    description { 'My description' }
    experience { 'My Experience is bla bla bla' }
    applicant { nil }
  end
end
