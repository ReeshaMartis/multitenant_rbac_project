class RefreshToken < ApplicationRecord
  belongs_to :user

  #using time.current for server time.
  scope:active, -> {where(revoked_at: nil).where("expires_at>?",Time.current)} 


end
