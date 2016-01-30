class Property < ActiveRecord::Base
  include PublicActivity::Common
  #acts_as_commentable
  belongs_to :list
end
