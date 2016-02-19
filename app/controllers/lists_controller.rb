class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_member, only: :show
  before_action :set_list, only: [:show, :edit, :update]

  def index
    @member = current_user.lists
    @lists = List.where(id: @member.ids).search(params[:search])
                 .page(params[:page]).per_page(5)

  end

  def show
    #byebug
    @invite = @list.invites.build
    @members = @list.user_ids
    @property_in_system = Property.where(:owner_id => current_user.id)
    @all_properties = Property.all
    @list = List.find(params[:id])
    @properties = @list.properties
    @hash = Gmaps4rails.build_markers(@properties) do |user, marker|
      marker.lat user.latitude
      marker.lng user.longitude
      #   marker.picture({
      #                      :url => "http://www.spainbuyingguide.com/_assets/media/library/SP-mortgage.png",
      #                      :width => 32,
      #                      :height => 32
      #                  })

    end
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
    @invite = @list.invites.build
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


  def add_property
    @list = List.find(params[:id])
    @members = @list.user_ids
    @mee = current_user.id

    if @mee.in?(@members)
      @l =  params[:list][:property_id]
      respond_to do |format|
        @propertiship = Propertyship.new
        @propertiship.list_id = @list.id
        @propertiship.property_id = @l
        if @propertiship.save
          @propertiship.create_activity :add_property, owner: current_user

          format.html { redirect_to list_path(@list), notice: 'Property Added' }
        else
          format.html { redirect_to list_path(@list), notice: 'Property Not Added' }
        end
      end
    else
      redirect_to :root
    end
  end




  private

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name, :user_id, :property_ids => [])
  end

  def invite_params
    params.require(:user).permit( :email, :name, :user_id, :list_id)
  end

  def authenticate_member
    @list = List.find(params[:id])
    @members = @list.user_ids
    @mee = current_user.id
    redirect_to :root unless @mee.in?(@members)
  end

  def authenticate_owner
    @list = List.find(params[:id])
    redirect_to :root unless current_user.id == @list.owner_id
  end

end
