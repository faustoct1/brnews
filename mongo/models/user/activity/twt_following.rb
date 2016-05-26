
class TwtFollowing
  include Mongoid::Document
  include Rankable::Twitter
  
  field :account_id, type: String
  field :following, type: Array

  index(account_id: 1)
    
  def self.build user
    twtfeed = []
    tfollowing = TwtFollowing.where(:account_id=>user['id'])
    unless tfollowing.nil?
        twtfeed = tfollowing.first.following unless tfollowing.first.nil?
    end
    twtfeed
  end
end

# threshold: number of page likes, number of results on google, keywords, black list, category weight/relevance, created-time 