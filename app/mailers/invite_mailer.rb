class InviteMailer < Devise::Mailer

  protected

  def subject_for(key)
    if key.to_s == 'invitation_instructions'
      "New Sanctuary Coalition (#{ @resource.community.name.upcase }) volunteer account invitation"
    else
      return super
    end
  end

end
