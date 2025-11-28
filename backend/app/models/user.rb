class User < ApplicationRecord
  
  has_secure_password

  belongs_to :tenant
  
  has_many :created_projects, class_name: 'Project', foreign_key: 'created_by_id'
  has_many :assigned_tasks, class_name: "Task", foreign_key: :assignee_id
  has_many :created_tasks, class_name: "Task", foreign_key: :created_by_id
  
  # enum role: {admin:0, manager:1 , contributor:2}

  extend Enumerize
  enumerize :role, in: { admin: 0, manager: 1, contributor: 2 }, default: :contributor, predicates: true


  validates :email, presence: true, uniqueness: {scope: :tenant_id}
  
  #  # helper methods for integer-backed roles
  # def admin?
  #   role.to_i == 0
  # end

  # def manager?
  #   role.to_i == 1
  # end

  # def contributor?
  #   role.to_i == 2
  # end
end
