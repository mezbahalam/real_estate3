class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

# GET /resource/sign_up
  def new
    super do |resource|
      @token = params[:invite_token]
    end

    # @token = params[:invite_token] #<-- pulls the value from the url query string
    # super
  end

  # POST /resource
  def create
    super do |resource|
      @token = params[:invite_token]
      if @token != nil
        # @add_member = Membership.new
        # @add_member.user_id =  resource.id
        # @org = Invite.find_by_token(@token) #find the list attached to the invite
        # @add_member.list_id = @org.list_id #add this user to the new list as a member
        # @add_member.save

        org = Invite.find_by_token(@token).list #find the calendar attached to the invite
        resource.lists.push(org) #add this user to the new calendar as a member
      end

    end


    # @newUser = build_resource(sign_up_params)
    # @newUser.save
    # @token = params[:invite_token]
    # if @token != nil
    #   org =  Invite.find_by_token(@token).list #find the list attached to the invite
    #   @newUser.list.push(org) #add this user to the new list as a member
    # else
    #   # do normal registration things #
    #   super
    # end
  end


  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end


end
