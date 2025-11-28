class Project < ApplicationRecord
  belongs_to :tenant
  belongs_to :created_by, class_name: 'User' 
  scope :active, -> { where(deleted_at: nil) }

  has_many :tasks

  # enum status: {active: 0, on_hold: 1, completed: 2}

  extend Enumerize
  enumerize :status, in: {active: 0, on_hold: 1, completed: 2}, default: :active, predicates: true


  validates :name, presence: true, uniqueness: {scope: :tenant_id}
end
