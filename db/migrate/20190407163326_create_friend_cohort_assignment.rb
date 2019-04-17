class CreateFriendCohortAssignment < ActiveRecord::Migration[5.2]
  def change
    create_table :friend_cohort_assignments do |t|
      t.integer :friend_id, :null => false
      t.integer :cohort_id, :null => false
      t.boolean :confirmed, :default => false

      t.timestamps :null => false
    end
  end
end
