class PropertiesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_owner, only: [:edit, :update, :destroy]
  before_action :find_list


  def index
  end


  def show
    @property = @list.properties.find(params[:id])
  end


  def new
    @property = @list.properties.new
  end


  def edit
    @property = @list.properties.find(params[:id])
  end


  def create
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

        format.html { redirect_to list_properties_path, notice: 'Property was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end


  def destroy
    @property = @list.properties.find(params[:id])
    @activity = PublicActivity::Activity.find_by(trackable_id: (params[:id]), trackable_type: controller_path.classify)
    @activity.destroy
    @property.destroy


    respond_to do |format|
      format.html { redirect_to list_properties_path, notice: 'Property was successfully destroyed.' }
    end
  end

  private
    def find_list
      @list =  current_user.lists.find(params[:list_id])
    end

    def property_params
      params.require(:property).permit(:street_address, :city, :state, :lat, :lon, :url, :photo_url, :description, :tags, :bedroom, :bathroom, :price, :status, :list_id)
    end

    def authenticate_owner
      @list = List.find(params[:list_id])
      redirect_to :root unless current_user.id == @list.owner_id
    end
end
