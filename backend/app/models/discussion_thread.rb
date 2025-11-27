class DiscussionThread < ApplicationRecord
  belongs_to :tenant
  belongs_to :task
  belongs_to :created_by, class_name: 'User' 

  has_many :replies
  has_many :attachments

  # enum status: {open: 0, responded: 1, resolved:2, archived:3}

  extend Enumerize
  enumerize :role, in: {open: 0, responded: 1, resolved:2, archived:3}, default: :open, predicates: true


  validates :task_id, uniqueness: { scope: :tenant_id }

end
