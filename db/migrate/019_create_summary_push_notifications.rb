class CreateSummaryPushNotifications < ActiveRecord::Migration
  def self.up
    create_table :summary_push_notifications do |t|
      t.boolean :notify
      t.string :registration_id
      t.string :type
      t.timestamps
    end
  end

  def self.down
    drop_table :summary_push_notifications
  end
end
