class Project < ApplicationRecord
  belongs_to :tenant
  belongs_to :created_by, class_name: 'User' 
  has_many :tasks
  
  scope :active, -> { where(deleted_at: nil) }
  scope :paginate, ->(page,per_page) {
    page = page.to_i >= 1? page.to_i : 1
    per_page = per_page.to_i >= 1 ? per_page.to_i : 20 
    
    offset((page-1)*per_page).limit(per_page)
  }

  

  # enum status: {active: 0, on_hold: 1, completed: 2}

  extend Enumerize
  enumerize :status, in: {active: 0, on_hold: 1, completed: 2}, default: :active, predicates: true


  validates :name, presence: true, uniqueness: {scope: :tenant_id}
end
