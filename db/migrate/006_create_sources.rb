class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.text :name
      t.text :website
      t.text :fb_page
      t.text :fb_id
      t.text :language
      t.timestamps
    end
  end

  def self.down
    drop_table :sources
  end
end
