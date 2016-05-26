class CreateStories < ActiveRecord::Migration
  def self.up
    create_table :stories do |t|
      t.text :uid_url
      t.text :source_type
      t.text :description
      t.text :title
      t.integer :published
      t.text :fb_story
      t.text :fb_pic
      t.text :fb_icon
      t.text :fb_type
      t.text :fb_from_category
      t.text :fb_from_name
      t.text :fb_from_id
      t.text :fb_status_type
      t.text :fb_message
      t.text :fb_link
      t.text :fb_caption
      t.text :ytb_thumbnail
      t.text :ytb_channelId
      t.text :ytb_videoId
      t.text :ytb_channel_name
      t.text :qtitle
      t.belongs_to :topic
      t.timestamps
    end

    add_index :stories, [:uid_url, :source_type]
  end

  def self.down
    drop_table :stories
  end
end
