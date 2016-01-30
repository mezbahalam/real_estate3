class ActivitiesController < ApplicationController
  def index
    #for last activity of current_user
    #@list = current_user.memberships.last.list
    #show activity for member
    @activities = PublicActivity::Activity.order("created_at desc")   #.where(owner_id: @list.members)  #or where(list_id: @membership.lists)
  end
end
