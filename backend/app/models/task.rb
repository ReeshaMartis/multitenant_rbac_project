class Task < ApplicationRecord
  belongs_to :tenant
  belongs_to :project
  belongs_to :assignee, class_name: 'User' 
  belongs_to :created_by, class_name: 'User' 
  has_one :discussion_thread

  include Paginatable

  scope :active, -> { where(deleted_at: nil) }
  
  #filter scopes
  scope :by_title, ->(name) { where("title ILIKE ?","%#{name}%") if name.present? }
  scope :by_status, ->(status) {where(status: status) if status.present? }
  scope :by_priority, ->(priority) {where(priority: priority) if priority.present? }
  scope :by_assignee, ->(assignee_id) {where(assignee_id: assignee_id)if assignee_id.present? }
  scope :by_creator, ->(creator_id) {where(created_by_id:creator_id) if creator_id.present? }
  scope :duedate_before, ->(date) {where("due_date <= ? ", date)if date.present? }
  scope :duedate_after, ->(date) {where("due_date >= ? ", date)if date.present? }
  scope :completed_before, ->(date) {where("completed_at <= ? ", date)if date.present? }
  scope :completed_after, ->(date) {where("completed_at >= ? ", date)if date.present? }
  scope :created_before, ->(date) {where("created_at <= ? ", date)if date.present? }
  scope :created_after, ->(date) {where("created_at >= ? ", date)if date.present? }

  extend Enumerize
  enumerize :status, in: {to_do: 0, in_progress: 1, blocked: 2, done:3}, default: :to_do, predicates: true


  validates :title, presence: true, uniqueness: {scope: [:tenant_id, :project_id]}

end
