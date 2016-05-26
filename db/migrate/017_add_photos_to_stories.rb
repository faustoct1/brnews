class AddPhotosToStories < ActiveRecord::Migration
  def self.up
    change_table :stories do |t|
      t.string :fb_full_pic
    #t.string :fb_pic
    end
  end

  def self.down
    change_table :stories do |t|
      t.remove :fb_full_pic
    #t.remove :fb_pic
    end
  end
end
