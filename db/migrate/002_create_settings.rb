class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.boolean :pt
      t.boolean :us
      t.boolean :website
      t.boolean :youtube
      t.boolean :wikipedia
      t.belongs_to :user, index: true
      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
