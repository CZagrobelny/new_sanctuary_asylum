class AddBasicColumnsToFriends < ActiveRecord::Migration[5.0]
  def change
  	add_column :friends, :middle_name, :string
  	add_column :friends, :no_a_number, :boolean, default: false, null: false
  	add_column :friends, :ethnicity, :integer
  	add_column :friends, :other_ethnicity, :string
  	add_column :friends, :gender, :integer
  	add_column :friends, :date_of_birth, :date
  	add_column :friends, :status, :integer
  	add_column :friends, :date_of_entry, :date
  	add_column :friends, :notes, :text
  	add_column :friends, :asylum_status, :integer
  	add_column :friends, :date_asylum_application_submitted, :date
  	add_column :friends, :lawyer_notes, :text
  	add_column :friends, :work_authorization_status, :integer
  	add_column :friends, :date_eligible_to_apply_for_work_authorization, :date
  	add_column :friends, :date_work_authorization_submitted, :date
  	add_column :friends, :work_authorization_notes, :text
  	add_column :friends, :sidj_status, :integer
  	add_column :friends, :date_sidj_submitted, :date
  	add_column :friends, :sidj_notes, :text
  end
end
