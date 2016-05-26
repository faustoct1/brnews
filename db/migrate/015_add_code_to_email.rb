class AddCodeToEmail < ActiveRecord::Migration
  def self.up
    change_table :emails do |t|
      t.string :code
    end
  end

  def self.down
    change_table :emails do |t|
      t.remove :code
    end
  end
end
