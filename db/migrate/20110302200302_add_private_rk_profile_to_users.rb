class AddPrivateRkProfileToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :rk_private, :boolean, :default => false
    User.update_all(:rk_private => false)
  end

  def self.down
    remove_column :users, :rk_private
  end
end
