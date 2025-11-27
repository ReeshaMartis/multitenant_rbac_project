class ChangeRoleStatusEnumColsToNotNull < ActiveRecord::Migration[8.0]
  def change
    change_column_null :users, :role, false, 2
    change_column_null :projects, :status,false, 0
    change_column_null :discussion_threads, :status,false, 0
    change_column_null :tasks, :status,false, 0

  end
end
