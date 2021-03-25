class CreateApplicantsOpportunities < ActiveRecord::Migration[6.1]
  def change
    create_table :applicants_opportunities do |t|
      t.references :applicant, null: false, foreign_key: true
      t.references :opportunity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
