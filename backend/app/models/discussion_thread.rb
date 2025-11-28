class DiscussionThread < ApplicationRecord
  belongs_to :tenant
  belongs_to :task
  belongs_to :created_by, class_name: 'User' 
  belongs_to :project 

  has_many :replies
  has_many :attachments

  # enum status: {open: 0, responded: 1, resolved:2, archived:3}

  extend Enumerize
  enumerize :status, in: {open: 0, responded: 1, resolved:2, archived:3}, default: :open, predicates: true


  validates :title, uniqueness: {  scope: [:tenant_id, :task_id] }
  validate :status_flow, on: :update

  private
    def status_flow
    return unless status_changed?

    allowed_transitions = {
      'open' => ['open', 'responded'],
      'responded' => ['responded', 'resolved'],
      'resolved' => ['resolved', 'archived'],
      'archived' => ['archived'] # cannot move back
    }

    unless allowed_transitions[status_was.to_s].include?(status.to_s)
      errors.add(:status, "cannot transition from #{status_was} to #{status}")
    end
  end

end
