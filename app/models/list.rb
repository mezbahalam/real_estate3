class List < ActiveRecord::Base
  include PublicActivity::Common
  #tracked owner: ->(controller, model) { controller && controller.current_user }
  acts_as_commentable
  acts_as_votable


  has_many :memberships
  has_many :users, :through => :memberships   #, :class_name => "User"

  has_many :propertyships
  has_many :properties, :through => :propertyships

  has_many :invites
  validates_presence_of :name


  # def self.search(term)
  #   where("name like :term", term: "%#{term}%")
  # end



  # searchable do
  #   text :name
  # end


  # def self.terms_for(prefix)
  #   suggestions = where("term like ?", "#{prefix}_%")
  #   suggestions.order("created_at asc").limit(10).map(&:term)
  # end
  #
  # def self.index_lists
  #   List.find_each do |list|
  #     index_term(list.name)
  #   end
  # end

  # before_destroy method overrides the default ruby destroy method that is called during dependent: :destroy
  # before_destroy :find_and_destroy_lists
  #
  # def find_and_destroy_lists
  #   activity = PublicActivity::Activity.find_by(trackable_id: self.id, trackable_type: self.class.name)
  #   if activity.present?
  #     activity.destroy
  #   end
  # end
end
