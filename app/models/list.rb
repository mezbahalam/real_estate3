class List < ActiveRecord::Base
  has_many :properties, dependent: :destroy

  has_many :memberships
  has_many :users, :through => :memberships#, :class_name => "User"
  validates_presence_of :name
end
