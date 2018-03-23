module AccompanimentHelper
  def accompaniment_user_details(accompaniment)
    user = accompaniment.user
    [user.phone, user.email].tap do |details|
      details << user.volunteer_type.humanize.titleize if user.volunteer?
      details << accompaniment.availability_notes if accompaniment.availability_notes.present?
    end
  end
end
