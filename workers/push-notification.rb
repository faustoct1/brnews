require 'padrino-core'
require 'active_record'
require 'json'
require 'rest_client'
require 'gcm'

puts "start"

["./config/database", "./models/summary_push_notification.rb"].each do |file|
  puts "Loading #{file}"
  require file
end

class BackgroundException < Exception
end



gcm = GCM.new("")
# you can set option parameters in here
#  - all options are pass to HTTParty method arguments
#  - ref: https://github.com/jnunemaker/httparty/blob/master/lib/httparty.rb#L40-L68
#  gcm = GCM.new("my_api_key", timeout: 3)

begin
  ids = SummaryPushNotification.select(:registration_id).all.map(&:registration_id)
  options = { data:{title: 'Confira o resumão do dia', message: 'Resumão de tecnologia, negócios, esporte, política e economia.'} }
  response = gcm.send_notification(ids,options)
  puts response
rescue Exception => e
  print e
end

#alert(data.image)
#registration_ids.each do |id|
#end
