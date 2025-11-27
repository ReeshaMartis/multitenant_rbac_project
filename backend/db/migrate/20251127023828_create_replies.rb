class CreateReplies < ActiveRecord::Migration[8.0]
  def change
    create_table :replies do |t|
      t.references :discussion_thread, null: false, foreign_key: true
      t.references :tenant, null: false, foreign_key: true
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.text :body
      t.integer :version

      t.timestamps
    end
  end
end
