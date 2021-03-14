class CreateApplicantProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :applicant_profiles do |t|
      t.string :name
      t.string :nickname
      t.date :birthdate
      t.string :formation
      t.string :description
      t.string :experience
      t.references :applicant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
