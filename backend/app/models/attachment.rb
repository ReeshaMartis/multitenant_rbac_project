class Attachment < ApplicationRecord
  belongs_to :discussion_thread
  belongs_to :tenant
end
