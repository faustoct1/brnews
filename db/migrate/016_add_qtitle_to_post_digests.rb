class AddQtitleToPostDigests < ActiveRecord::Migration
  def self.up
    change_table :post_digests do |t|
      t.string :qtitle
    end
  end

  def self.down
    change_table :post_digests do |t|
      t.remove :qtitle
    end
  end
end
