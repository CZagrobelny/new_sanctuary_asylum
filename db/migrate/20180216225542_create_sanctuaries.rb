class CreateSanctuaries < ActiveRecord::Migration[5.0]
  def change
    create_table :sanctuaries do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state, :limit => 2
      t.string :zip_code
      t.string :leader_name
      t.string :leader_phone_number
      t.string :leader_email
    end
  end
end
