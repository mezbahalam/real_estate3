class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_owner, only: [:edit, :update, :destroy]
  before_action :set_list, only: [:show, :edit, :update]
  # before_filter :restrict_only_invited_users


  def index
    @lists = current_user.lists.all

    # @lists = List.all
    #@member = User.invitation_accepted
    #@creator = User.created_by_invite
  end

  def show
    @members = @list.users

    @list = List.find(params[:id])
    @comments = @list.comment_threads.order('created_at desc')
    @new_comment = Comment.build_from(@list, current_user.id, "")
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    @list.user_id = current_user.id
    @list.owner_id = current_user.id

    respond_to do |format|
      if @list.save
        @add_member = Membership.new
        @add_member.user_id =  @list.user_id
        @add_member.list_id = @list.id
        @add_member.save
        @list.create_activity :create, owner: current_user


        format.html { redirect_to lists_path, notice: 'List was successfully created.' }
      else
        format.html { render :new }
      end

    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @list.update(list_params)
        @list.create_activity :update, owner: current_user

        format.html { redirect_to lists_path, notice: 'List was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end


  def destroy
    @list = current_user.lists.find(params[:id])
    @activity = PublicActivity::Activity.find_by(trackable_id: (params[:id]), trackable_type: controller_path.classify)
    @activity.destroy
    @list.destroy

    respond_to do |format|
      format.html { redirect_to lists_url, notice: 'List was successfully destroyed.' }
    end
  end



  def invite
    # Set the current list
    @list = List.find(params[:id])
    @user = User.find_by(email: invite_params[:email])
    # @user is an instance or nil
    if @user && @user.email != current_user.email
      # invite! instance method returns a Mail::Message instance
      @user.invite!(current_user)
      # return the user instance to match expected return type
      @user
      @user.lists << @list
    else
      # invite! class method returns invitable var, which is a User instance
      #resource_class.invite!(invite_params, current_inviter, &block)

      # Create your own invite_params method to allow user_name and email
      invited_user = User.invite!(invite_params, current_user)

      # If a complex association through a separate memberships table
      invited_user.lists << @list
    end

    redirect_to list_path
  end


  private

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name, :user_id)
  end

  def invite_params
    params.require(:user).permit( :email, :name, :user_id, :list_id)
  end




  # def restrict_only_invited_users
  #   redirect_to :root if current_user.invitation_accepted_at.blank?
  # end

  #authenticate_member!

  def authenticate_owner
    @list = List.find(params[:id])
    redirect_to :root unless current_user.id == @list.owner_id
  end

end
