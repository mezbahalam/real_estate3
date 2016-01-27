class List < ActiveRecord::Base
  belongs_to :user
  has_many :properties, dependent: :destroy
  validates_presence_of :name
end
