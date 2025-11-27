class AddDefaultStatusToProjectsAndDiscussionThreads < ActiveRecord::Migration[8.0]
  def change
     change_column_default :projects, :status, 0
    change_column_default :discussion_threads, :status, 0
    change_column_default :tasks, :status, 0
  end
end
