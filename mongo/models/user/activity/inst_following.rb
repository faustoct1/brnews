
class InstFollowing
  include Mongoid::Document
  include Rankable::Instagram
  
  field :account_id, type: String
  field :following, type: Array

  index(account_id: 1)
    
  def self.build user
    instfeed = []
    ifollowing = InstFollowing.where(:account_id=>user['id']).first
    unless ifollowing.nil?
        client = Instagram.client(:access_token => user['credentials']['token'])
        ifollowing['following'][0..5].each do |item|
          #@instfeed << client.user_media_feed(item['id'],:count=>1)
          instfeed << client.user_recent_media(item['id'],{:count=>1})
        end 
    end 
    instfeed
  end
end

# threshold: number of page likes, number of results on google, keywords, black list, category weight/relevance, created-time 