class Property < ActiveRecord::Base
  include PublicActivity::Common
  belongs_to :list
  acts_as_commentable
  acts_as_votable
  geocoded_by :street_address
  after_validation :geocode
end
