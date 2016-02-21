class PropertiesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_owner, only: [:edit, :update, :destroy]


  def index
    @properties = Property.where(owner_id: current_user.id).page(params[:page]).per_page(10)
  end


  def show
    @current_user_lists = current_user.lists
    @property = Property.find(params[:id])

    @hash = Gmaps4rails.build_markers(@property) do |user, marker|
      marker.lat user.latitude
      marker.lng user.longitude
      #   marker.picture({
      #                      :url => "http://www.spainbuyingguide.com/_assets/media/library/SP-mortgage.png",
      #                      :width => 32,
      #                      :height => 32
      #                  })

    end

    @tags_ids = @property.tag_list

    @tags = ActsAsTaggableOn::Tag.where(:id => @tags_ids)

    @comments = @property.comment_threads.order('created_at desc')
    @new_comment = Comment.build_from(@property, current_user.id, "")


  end


  def new
    @property = Property.new
  end


  def edit
    @tags_ids = @property.tag_list
    @tags = ActsAsTaggableOn::Tag.where(:id => @tags_ids)
  end


  def create
    @property = Property.new(property_params)
    @property.owner_id = current_user.id
    respond_to do |format|
      if @property.save
        @property.create_activity :create, owner: current_user

        format.html { redirect_to property_path(@property), notice: 'Property was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end


  def update
    @property = Property.find(params[:id])
    respond_to do |format|
      if @property.update_attributes(property_params)
         @property.create_activity :update, owner: current_user

        format.html { redirect_to property_path(@property), notice: 'Property was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end


  def destroy


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



  def add_to_list
    @property = Property.find(params[:id])
    @l =  params[:property][:list_id]

    respond_to do |format|
      @propertiship = Propertyship.new
      @propertiship.property_id = @property.id
      @propertiship.list_id = @l
      if @propertiship.save
        @property.create_activity :add_to_list, owner: current_user
        format.html { redirect_to property_path(@property), notice: 'Property Added' }
      else
        format.html { redirect_to property_path(@property), notice: 'Property Not Added' }
      end
    end
  end



    def tags
      query = params[:q]
      if query[-1,1] == " "
        query = query.gsub(" ", "")
        ActsAsTaggableOn::Tag.find_or_create_with_like_by_name(query)
      end

      @tags = ActsAsTaggableOn::Tag.where("tags.name LIKE ?", "%#{query}%")
      respond_to do |format|
        format.json { render :json => @tags.map{|t| {:id => t.name, :name => t.name }}}
      end
    end


  private

    def property_params
      params.require(:property).permit(:tag_list ,:street_address, :city, :state, :lat, :lon, :url , :photo_url, :description, :tags, :bedroom, :bathroom, :price, :status,:remote_photo_url_url,{:list_ids => []}, pictures: [])
    end

    def authenticate_owner
      @property = Property.find(params[:id])
      redirect_to :root unless current_user.id == @property.owner_id
    end
end
