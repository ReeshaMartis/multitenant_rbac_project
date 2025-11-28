class AddProjectIdToDiscussionThreads < ActiveRecord::Migration[8.0]
  def change
    add_reference :discussion_threads, :project, null: false, foreign_key: true
  end
end
