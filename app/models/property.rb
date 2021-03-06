class Property < ActiveRecord::Base
  mount_uploader :photo_url, ImageUploader
  serialize :pictures, Array
  mount_uploaders :pictures, ImageUploader
  include PublicActivity::Common

  has_many :propertyships
  has_many :lists, :through => :propertyships

  acts_as_taggable_on :tags
  acts_as_commentable
  acts_as_votable
  geocoded_by :street_address
  after_validation :geocode


  def self.search(term)
    where("street_address like :term", term: "%#{term}%")
  end


end
