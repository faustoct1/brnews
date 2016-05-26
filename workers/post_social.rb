#require 'bundle/bundler/setup'

require 'padrino-core'
require 'active_record'
require 'json'
require 'koala'
require 'twitter'
require 'google/api_client'
require 'rest_client'
require 'gcm'

puts "start"

["./config/database", "./models/story","./models/source","./models/topic","./models/source_topic","./models/user_topic", "./models/source_miss","./models/post_digest","./models/summary_push_notification.rb"].each do |file|
  puts "Loading #{file}"
  require file
end

class PostException < Exception
end

Koala.config.api_version = "v2.4"

def stories_by_periods periods
  stories_by_periods = {morning:{},afternoon:{}}

  topic_ids = [2,3,4,5,6]

  periods.each do |key, value|
    topic_ids.each do |topic_id|
      story = Story.select(:fb_full_pic,:topic_id, :published, :title, :fb_from_name, :fb_link,:qtitle).where("published >= #{value.first.to_i} and published <= #{value.last.to_i} and topic_id = #{topic_id}")
      stories_by_periods[key][topic_id] = story unless story.blank?
    end
  end

  r={}

  stories_by_periods.each do |period,by_topic|
    r[period]=[]

    by_topic.each do |topic,stories|
      r[period] << stories[stories.length/4]
      r[period] << stories[stories.length/2]
      r[period] << stories[(stories.length/2) + (stories.length/4)]
    end
  end

  r
end

def day_str
  now = DateTime.now
  sday = case now.cwday
    when 1
      'Segunda'
    when 2
      'Terça'
    when 3
      'Quarta'
    when 4
      'Quinta'
    when 5
      'Sexta'
    when 6
      'Sábado'
    when 7
      'Domingo'
    end
  "#{sday} #{now.day}"
end

def build_post r
  #implement here build page contain data
  #save on different table
  #create page for it

  msgs = {}
  digest = {}
  topics={}
  r.each do |p,stories|
    _msgs={}
    stories.each do |story|
      if _msgs[story[:topic_id]].blank?
        topic=Topic.select(:pt).where("id = #{story[:topic_id]}").first[:pt]
        _msgs[story[:topic_id]] = "#{topic}: #{story[:title][0..50]}..\n"
        topics[:topic_id] = topic
      end
      digest[p] = [] if digest[p].blank?
      digest[p] << {fb_full_pic: story[:fb_full_pic] ,title: story[:title], topic_name: topics[:topic_id], period: p, source: story[:fb_from_name], published: story[:published], url: story[:fb_link], qtitle: story[:qtitle]}
    end
    msgs.merge! _msgs
  end

  digest.each do |p,posts|
    unless digest[p].blank?
      PostDigest.create(digest[p])
    end if PostDigest.where("period like '#{p}'").blank?
  end

  return

  fb_post = ""
  twt_post = ""
  period = nil
  unless r[:morning].blank?
    fb_post = "Bom dia. Hojé é #{day_str}. \nE esse é o resumão da manhã:\n\n"
    period = :morning
  end

  unless r[:afternoon].blank?
    fb_post = "Boa tarde. Hojé é #{day_str}. E esse é o resumão da tarde:\n\n"
    period = :afternoon
  end

  twt_post = fb_post

  msgs.each do |topicid,msg|
    fb_post = fb_post + msg
  end

  fb_post = fb_post + "\nConfira o resumão dos principais acontecimentos na integra.\n"
  fb_post = fb_post + "http://www.brnews.co/resumao-do-dia\n\n"
  fb_post = fb_post + "Clique e confira!!"

  twt_post = twt_post + "http://www.brnews.co/resumao-do-dia #brnews #noticias #resumao"

  {fb: fb_post, twt: twt_post}
end

def post_social posts
  #post on facebook
  Koala.config.api_version = "v2.4"
  #page_graph = Koala::Facebook::API.new('CAAKRyoBx1tkBAND8n2hH5ZAuP60ZAcKYfGnazpE5GPDil5IwkpMtInCA6I1DRAfh8BBCreNGxwynvT6I7OJlD2kUYGUQ9qNlb4Tqc7WMUL3fCuZAQqSxsrCGPUM94QtjDJgsAcM21dO518rZBlMuD1Qy5lzfsJ1VjMpZC61aP9VDgYwQuK5PHNa74ho48AtAZD')
  page_graph = Koala::Facebook::API.new('CAAKRyoBx1tkBAKyeVjVZBuDnxZBJ3ZBCSDOeOmHJRaLiQ5dRef13rarFvOlQ997zHAdavge5DmsG83ZBJgMcRM18Gv33VQ6oXJOdsfmhsJPzr0ZA6ocBQheZA3SyVTTweQr2hli7Vc8t8k1IgHtqWIAsnMsdArg8Dg6RlXXsmSuPOlj0ddnZBFv')
  page_graph.put_connections('1698395137050407', 'feed', :message => posts[:fb], :picture => '', :link => 'http://www.brnews.co/resumao-do-dia')

  #post on facebook
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = "PsU7NyczBD6YOsyh5lVCnGILy"
    config.consumer_secret     = "yp7Ez9s5ooyR6Zj5Nr69V2UFyDKa2LrHXzI4JR2FB6ARufYZDU"
    config.access_token        = "3633124275-wjjJJlCmq2nhbYws6Hd9NqaOLhXrZio8dgCyCCo"
    config.access_token_secret = "Jzv7TVgio3RYnaftMrLKfhCobtfaaq9t57zheCaGKufim"
  end
  client.update(posts[:twt])
end

def posts
  #get stories between 8-14
  #get stories between 12-18

  #posted at 12.30pm (heroku 2.30pm) and 18.30pm (heroku 20.30pm)

if 'morning' == ARGV[0]
  PostDigest.delete_all
  periods = {morning:[DateTime.now.change({ hour: 8 }), DateTime.now.change({ hour: 12 })]}
elsif 'afternoon' == ARGV[0]
  periods = {afternoon:[DateTime.now.change({ hour: 14 }), DateTime.now.change({ hour: 18 })]}
else
  PostDigest.delete_all
  periods = {
    morning:[DateTime.now.change({ hour: 8}), DateTime.now.change({ hour: 12})],
    afternoon:[DateTime.now.change({ hour: 14 }), DateTime.now.change({ hour: 18 })]
  }

  gcm = GCM.new("AIzaSyDl3Iq2Ri4BFF6XEKLSbxiL7qOS57HqStM")
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
  #periods = {
  #  morning:[1.day.ago.change({ hour: 8}), 1.day.ago.change({ hour: 12})],
  #  afternoon:[1.day.ago.change({ hour: 14 }), 1.day.ago.change({ hour: 18 })]
  #}
end

  r=stories_by_periods periods
  posts = build_post r
  #post_social posts
end

posts

puts "end"
