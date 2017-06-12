class CreateFriendLanguages < ActiveRecord::Migration[5.0]
  def change
    create_table :friend_languages do |t|
    	t.belongs_to :friend, :null => false
        t.belongs_to :language, :null => false

        t.timestamps :null => false
    end
  end
end
