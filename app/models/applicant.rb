class Applicant < ActiveRecord::Base
  has_one :applicant_profile
  has_many :applicants_opportunities
  has_many :opportunities, through: :applicants_opportunities
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
end
