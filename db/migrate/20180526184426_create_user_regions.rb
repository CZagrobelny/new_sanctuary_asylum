class CreateUserRegions < ActiveRecord::Migration[5.0]
  def change
    create_table :user_regions do |t|
      t.belongs_to :region, foreign_key: true
      t.belongs_to :user, foreign_key: true
    end
  end
end
