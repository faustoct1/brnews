require 'time'

class FeedLookup
  include Chain::Executor
  def run user
    by=:source
    feeds = []
    case by
      when :recent
        user.accounts.each do |k,v|
          feeds.concat feed(v)
        end        
      else
        user.accounts.each do |k,v|
          feeds.concat feed(v)
        end
        
        feeds.sort_by! do |v|
          case v[:from]
            when :facebook
              v[:data].first['when'] = Time.parse(v[:data].first['created_time']).to_i unless v[:data].first['created_time'].class==Fixnum   
              -v[:data].first['when']
            when :google_oauth2 
              v[:data]['when']=v[:data]['publishedAt'].to_i unless v[:data]['when'].class==Fixnum 
              -v[:data]['when']
          end
        end
    end

    feeds #FIXME URGENT!!!
  end

  def feed user
    f=[]

    #FIXME GET FROM => FbPage && YtbVideo by user preferences!

    case user['provider']
      when 'facebook'
        f = FbPage.content(user['id'],user['credentials']['token'])
      when 'google_oauth2'      
        f = YtbChannel.content(user['id'])
      when 'linkedin'
        raise "not implemented"
      when 'twitter'
        raise "not implemented"
      when 'instagram'
        raise "not implemented"  
    end
 
    f
  end
end