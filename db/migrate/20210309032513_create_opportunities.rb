class CreateOpportunities < ActiveRecord::Migration[6.1]
  def change
    create_table :opportunities do |t|
      t.string :title
      t.string :hirer
      t.string :description
      t.string :requirements
      t.string :location
      t.references :head_hunter, null: false, foreign_key: true

      t.timestamps
    end
  end
end
