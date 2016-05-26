#require 'bundle/bundler/setup'

require 'padrino-core'
require 'active_record'
require 'json'
require 'koala'
require 'google/api_client'
#require 'iron_worker_ng'
require 'rest_client'

puts "start"

["./config/database", "./models/story","./models/source","./models/topic","./models/source_topic","./models/user_topic", "./models/source_miss"].each do |file|
  puts "Loading #{file}"
  require file
end

story_count = Story.count
source_miss_count = SourceMiss.count

ids = SourceMiss.order('created_at asc').pluck(:id)
SourceMiss.where(id: ids).delete_all

if story_count > 7000
  puts "delete miss sources"
  ids = SourceMiss.order('created_at asc').limit(1000).pluck(:id)
  SourceMiss.where(id: ids).delete_all
end

story_count = Story.count
if story_count > 7000
  puts "delete stories"
  ids = Story.order('created_at asc').limit(1000).pluck(:id)
  Story.where(id: ids).delete_all
end

puts "end"
