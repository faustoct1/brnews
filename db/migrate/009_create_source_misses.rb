class CreateSourceMisses < ActiveRecord::Migration
  def self.up
    create_table :source_misses do |t|
      t.text :uid
      t.text :url
      t.text :source_type
      t.text :reason
      t.timestamps
    end
  end

  def self.down
    drop_table :source_misses
  end
end
