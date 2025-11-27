class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :status
      t.integer :priority
      t.references :assignee, null: false, foreign_key: { to_table: :users }
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.date :due_date
      t.datetime :completed_at

      t.timestamps
    end
  end
end
