class RenameTypeSummaryPushNotification < ActiveRecord::Migration
  def change
    rename_column :summary_push_notifications, :type, :action
  end
end
