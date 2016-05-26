class AddQtitleToStories < ActiveRecord::Migration
  def self.up
    change_table :stories do |t|
      t.string :qtitle
    end
  end

  def self.down
    change_table :stories do |t|
      t.remove :qtitle
    end
  end
end
