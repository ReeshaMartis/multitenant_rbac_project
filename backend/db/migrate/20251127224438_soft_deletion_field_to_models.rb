class SoftDeletionFieldToModels < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :deleted_at, :datetime
    add_index :projects, :deleted_at
    add_column :tasks, :deleted_at, :datetime
    add_index :tasks, :deleted_at

  end
end
