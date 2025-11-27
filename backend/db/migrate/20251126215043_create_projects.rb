class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.references :tenant, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.integer :status
      t.date :target_date
      t.references :created_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
