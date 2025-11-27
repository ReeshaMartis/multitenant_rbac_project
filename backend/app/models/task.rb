class Task < ApplicationRecord
  belongs_to :tenant
  belongs_to :project
  belongs_to :assignee, class_name: 'User' 
  belongs_to :created_by, class_name: 'User' 

  has_one :discussion_thread

  # enum status: {to_do: 0, in_progress: 1, blocked: 2, done:3}

  extend Enumerize
  enumerize :role, in: {to_do: 0, in_progress: 1, blocked: 2, done:3}, default: :to_do, predicates: true


  validates :title, presence: true, uniqueness: {scope: [:tenant_id, :project_id]}

end
