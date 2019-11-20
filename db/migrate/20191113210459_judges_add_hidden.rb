class JudgesAddHidden < ActiveRecord::Migration[5.2]
  def change
    add_column :judges, :hidden, :boolean, default: false
  end
end
