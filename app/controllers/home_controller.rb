class HomeController < ApplicationController
 before_action :authenticate_user!
  def index
    @users = User.all
  end

 def show
   @member = current_user.lists
   @lists = List.where(id: @member.ids).search(params[:search])
                .page(params[:page]).per_page(5)

   @properties = Property.search(params[:search])
                .page(params[:page]).per_page(5)
 end

end
