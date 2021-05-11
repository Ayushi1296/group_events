class User < ApplicationRecord
  has_many :group_events, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, uniqueness: true
end
