class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.text :facebook_uid
      t.text :facebook_name
      t.text :facebook_email
      t.text :facebook_image
      t.text :facebook_token
      t.boolean :facebook_verified

      t.text :google_oauth2_uid
      t.text :google_oauth2_name
      t.text :google_oauth2_email
      t.text :google_oauth2_image
      t.text :google_oauth2_token
      t.boolean :google_oauth2_verified

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
