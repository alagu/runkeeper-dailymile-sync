class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :last_activity_id
      t.string :access_token, :runkeeper_id, :provider, :dailymile_id, :name
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
