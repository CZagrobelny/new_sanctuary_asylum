class AddAttendedTrainingToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :attended_training, :boolean
  end
end
