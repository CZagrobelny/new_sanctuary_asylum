class CreatePartnerRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :partner_relationships do |t|
      t.integer :friend_id, null: false
      t.integer :partner_id, null: false

      t.timestamps
    end
  end
end
