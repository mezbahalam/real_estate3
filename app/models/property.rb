class Property < ActiveRecord::Base
  include PublicActivity::Common
  acts_as_commentable
  acts_as_votable

  belongs_to :list
end
