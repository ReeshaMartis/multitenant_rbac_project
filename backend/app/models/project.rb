class Project < ApplicationRecord
  belongs_to :tenant
  belongs_to :created_by, class_name: 'User' 

  has_many :tasks

  enum status: {active: 0, on_hold: 1, completed: 2}

  validates :name, presence: true, uniqueness: {scope: :tenant_id}
end
