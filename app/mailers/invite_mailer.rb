class InviteMailer < ApplicationMailer
  default from: 'real_estate@example.com'

  def existing_user_invite(invite, link)
    @receiver = invite
    @link = link
    mail to: invite.email, subject: "List Invitation"
  end

  def new_user_invite(invite, link)
    @receiver = invite
    @link = link
    mail to: invite.email, subject: "List Invitation"
  end

end

