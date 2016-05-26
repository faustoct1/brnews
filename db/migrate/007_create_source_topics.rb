class CreateSourceTopics < ActiveRecord::Migration
  def self.up
    create_table :source_topics do |t|
      t.belongs_to :source, index: true
      t.belongs_to :topic, index: true
      t.timestamps
    end
  end

  def self.down
    drop_table :source_topics
  end
end
