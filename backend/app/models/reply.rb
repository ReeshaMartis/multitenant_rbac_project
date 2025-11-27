class Reply < ApplicationRecord
  belongs_to :discussion_thread
  belongs_to :tenant
  belongs_to :created_by, class_name: 'User'

  validates :body, presence: true
  validates :version, presence: true
end
