class InvitesController < ApplicationController


  def create
    @invite = Invite.new(invite_params) # Make a new Invite
    @invite.sender_id = current_user.id # set the sender to the current user
    if @invite.save
      #if the user already exists
      if @invite.recipient != nil
        #send a notification email
        InviteMailer.existing_user_invite(@invite, new_user_session_path).deliver

        #Add the user to the list
        @invite.recipient.lists.push(@invite.list)
      else
        InviteMailer.new_user_invite(@invite, new_user_registration_path(:invite_token => @invite.token)).deliver #send the invite data to our mailer to deliver the email
      end
    else
      creating an new invitation failed
    end
  end


  private

  def invite_params
    params.require(:invite).permit(:email,:list_id,:sender_id,:recipient_id, :token)
  end
end
