class AddPicToPostDigests < ActiveRecord::Migration
  def self.up
    change_table :post_digests do |t|
      t.string :fb_full_pic
    end
  end

  def self.down
    change_table :post_digests do |t|
      t.remove :fb_full_pic
    end
  end
end
