class Tenant < ApplicationRecord
    has_many :users
    has_many :projects
    has_many :tasks, through: :projects
    has_many :discussion_threads, through: :tasks
end
