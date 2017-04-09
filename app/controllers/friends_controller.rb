class FriendsController < ApplicationController
  def index
    @friends = Friend.all
  end

  private
  def friend_params
    params.require(:friend).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :a_record,
      :address,
      :address2,
      :city,
      :state,
      :zip
    )
  end
end