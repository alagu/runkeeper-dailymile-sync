class AddStateToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :state, :string
    add_index :users, :state
  end

  def self.down
    remove_column :users, :state
  end
end
