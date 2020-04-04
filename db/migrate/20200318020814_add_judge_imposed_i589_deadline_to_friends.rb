class AddJudgeImposedI589DeadlineToFriends < ActiveRecord::Migration[5.2]
  def change
    add_column :friends, :judge_imposed_i589_deadline, :datetime
  end
end
