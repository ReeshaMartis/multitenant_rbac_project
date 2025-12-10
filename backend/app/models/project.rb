class Project < ApplicationRecord
  belongs_to :tenant
  belongs_to :created_by, class_name: 'User' 
  has_many :tasks
  
  include Paginatable
  scope :active, -> { where(deleted_at: nil) }
  #filter scopes
  scope :by_status, ->(status) {where(status: status) if status.present? }
  scope :by_name, ->(name)  {where("name ILIKE ?","%#{name}%") if name.present? }
  scope :by_creator, ->(creator_id) {where(created_by_id: creator_id) if creator_id.present? }
  scope :target_before, ->(date) {where("target_date <= ?",date) if date.present? }
  scope :target_after, ->(date) {where("target_date >= ?",date) if date.present? }
  scope :created_before, ->(date) {where("created_at <= ?",date) if date.present? }
  scope :created_after, ->(date) {where("created_at >= ?",date) if date.present? }
  

  extend Enumerize
  enumerize :status, in: {active: 0, on_hold: 1, completed: 2}, default: :active, predicates: true


  validates :name, presence: true, uniqueness: {scope: :tenant_id}
end
