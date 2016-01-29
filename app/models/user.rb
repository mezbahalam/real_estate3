class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,:validatable #, :confirmable

  has_many :memberships
  has_many :lists,  :through => :memberships

end
