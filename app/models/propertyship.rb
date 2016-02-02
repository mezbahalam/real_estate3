class Propertyship < ActiveRecord::Base
  belongs_to :list
  belongs_to :property
end
