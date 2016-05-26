class AddPubSrcUrlToPostDigests < ActiveRecord::Migration
  def self.up
    change_table :post_digests do |t|
      t.integer :published
    t.string :source
    t.string :url
    end
  end

  def self.down
    change_table :post_digests do |t|
      t.remove :published
    t.remove :source
    t.remove :url
    end
  end
end
