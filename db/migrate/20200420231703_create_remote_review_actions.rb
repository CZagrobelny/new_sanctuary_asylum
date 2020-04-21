class CreateRemoteReviewActions < ActiveRecord::Migration[5.2]
  def change
    create_table :remote_review_actions do |t|
      t.string :action, null: false
      t.integer :friend_id, null: false
      t.integer :user_id, null: false
      t.integer :region_id, null: false
      t.index :region_id
      t.integer :community_id, null: false
      t.integer :application_id, null: false
      t.integer :draft_id
      t.timestamps
    end
  end
end
