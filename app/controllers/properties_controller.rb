class PropertiesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_owner, only: [:edit, :update, :destroy]
  before_action :find_list, only: [:edit, :update, :destroy]


  def index
    @list = current_user.lists.find(params[:list_id])
    @properties = @list.properties.all

  end


  def show
    @property = Property.find(params[:id])
    @comments = @property.comment_threads.order('created_at desc')
    @new_comment = Comment.build_from(@property, current_user.id, "")
  end


  def new
    @list = List.find(params[:list_id])
    @property = @list.properties.new
  end


  def edit
  end


  def create
    @list = List.find(params[:list_id])
    @property = @list.properties.new(property_params)
    @property.owner_id = current_user.id
    respond_to do |format|
      if @property.save
        @property.create_activity :create, owner: current_user

        format.html { redirect_to list_properties_path, notice: 'Property was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end


  def update
    @property = @list.properties.find(params[:id])
    respond_to do |format|
      if @property.update_attributes(property_params)
        @property.create_activity :update, owner: current_user

        format.html { redirect_to list_properties_path(@list), notice: 'Property was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end


  def destroy
    # @property = Property.find(params[:id])
    #
    # @property_list = @property.list_id
    # @list = List.find(@property_list)

    @activity = PublicActivity::Activity.find_by(trackable_id: (params[:id]), trackable_type: controller_path.classify)
    @activity.destroy
    @property.destroy

    respond_to do |format|
      format.html { redirect_to list_properties_path(@list), notice: 'Property was successfully destroyed.' }
    end
  end


  def like
    @property = Property.find(params[:id])
    @property.liked_by current_user

    if request.xhr?
      render json: { count: @property.get_likes.size, id: params[:id] }
    else
      redirect_to @property
    end
  end

  private
    def find_list

      @property = Property.find(params[:id])
      @property_list = @property.list_id
      @list = List.find(@property_list)

      #@set_property = Property.find(params[:id])
      # @property_list = @set_property.list_id
      # @list = List.find(@property_list)
      # @list.users
    end

    def property_params
      params.require(:property).permit(:street_address, :city, :state, :lat, :lon, :url, :photo_url, :description, :tags, :bedroom, :bathroom, :price, :status, :list_id)
    end

    def authenticate_owner
      @property = Property.find(params[:id])
      redirect_to :root unless current_user.id == @property.owner_id
    end
end
