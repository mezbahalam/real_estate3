class ActivitiesController < ApplicationController
  before_action :authenticate_user!


  def index

    @friends = current_user.all_following.unshift(@user)
    @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: @friends).page(params[:page]).per_page(10)  #or where(list_id: @membership.lists)

  end

end
