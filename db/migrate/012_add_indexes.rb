class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :stories, :qtitle
  end

  def self.down
    remove_index :stories, :qtitle
  end
end
