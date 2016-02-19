class Propertyship < ActiveRecord::Base
  include PublicActivity::Common
  belongs_to :list
  belongs_to :property
end
