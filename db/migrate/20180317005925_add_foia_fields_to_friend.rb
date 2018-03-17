class AddFoiaFieldsToFriend < ActiveRecord::Migration[5.0]
  def change
    add_column :friends, :date_foia_request_submitted, :datetime
    add_column :friends, :foia_request_notes, :text
  end
end
