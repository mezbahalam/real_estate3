module UsersHelper

  def avatar_url(user)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48"
  end

  def is_current_user?(user)
    user == current_user
  end

  def full_name(user)
    "#{user.first_name}" + " " + "#{user.last_name }"
  end
end