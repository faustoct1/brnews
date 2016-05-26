class CreatePostDigests < ActiveRecord::Migration
  def self.up
    create_table :post_digests do |t|
      t.string :title
      t.string :topic_name
      t.string :period
      t.timestamps
    end
  end

  def self.down
    drop_table :post_digests
  end
end
