class CreateDiscussionThreads < ActiveRecord::Migration[8.0]
  def change
    create_table :discussion_threads do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.string :title
      t.text :body
      t.integer :status
      t.references :created_by, null: false, foreign_key: true

      t.timestamps
    end
  end
end
