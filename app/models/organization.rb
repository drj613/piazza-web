class Organization < ApplicationRecord
  has_many :memberships, dependent: :destroy
  # "members" reads better than "users"
  # source: tells ActiveRecord to use the user_id foreign key for this relation
  has_many :members, through: :memberships, source: :user
end
