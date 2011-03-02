class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :id, :user_id
      t.text :content, :response
      t.boolean :success
      t.timestamps
    end
    add_index :activities, :user_id
  end

  def self.down
    remove_index :activities, :column => :user_id
    drop_table :activities
  end
end
