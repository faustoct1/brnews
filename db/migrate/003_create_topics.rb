class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.text :name
      t.text :us
      t.text :pt
      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end
