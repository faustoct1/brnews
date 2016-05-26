require 'rubygems'

class ProfileLookup
  include Chain::Executor

  def run user
    #build a singular profile!
    #1st fb
    #2nd linkedin
    #3rd g+
    #4th insta
    #5th twitter

    profile={}

    [:facebook, :linkedin, :google_oauth2, :instagram, :twitter].each do |p|
      account = user.accounts[p.to_s]

      if account.nil?
        profile[p]={:pic=>nil,:interests=>[]}
        next
      end

      case p
        when :facebook
          profile[p]=Facebook.new.get(user)
        when :linkedin
          #profile[p]={:pic=>Facebook.new.get(user),:interests=>user.accounts[p]}
        when :google_oauth2
          profile[p]=Google_.new.get(user)
        when :instagram
        when :twitter
      end unless account.nil?
    end

    profile
  end

  class ProfileFactory
    def get user
    end
  end

  class Facebook < ProfileFactory
    def get user
      account = user.accounts["facebook"]
      graph = Koala::Facebook::API.new
      puts "here"
      puts account['uid']
      pic=graph.get_connection(account['uid'], "picture?redirect=false")

      likes=user.fb_likes_name
      puts account
      {
        :pic=>pic['data']['url'],
        :interests=>likes,
        :info=> {
          :first_name=>account['info']['first_name'],
          :last_name=>account['info']['last_name'],
          :gender=>account['info']['gender'],
          :email=>account['info']['email']
        }
      }
    end
  end

  class Google_  < ProfileFactory
    def get user
      account = user.accounts["google_oauth2"]
      client = Google::APIClient.new
      authorization = Signet::OAuth2::Client.new(
        :authorization_uri => 'https://accounts.google.com/o/oauth2/auth',
        :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
        :client_id => '',
        :client_secret => '',
        :redirect_uri => '',
        :scope => 'profile,plus.login,email,https://www.googleapis.com/auth/youtube,https://www.googleapis.com/auth/youtube.readonly,https://www.googleapis.com/auth/plus.me'
      )
puts account
      authorization.access_token = account['credentials']['token']
      client.authorization = authorization

      profile=client.execute!(
        :api_method => client.discovered_api("plus").people.get,
        :parameters => {
          :userId => 'me'
        }
      )

      subs=user.ytb_subscriptions_name

      {
        :pic=>profile.data.image.url,
        :interests=>subs,
        :info=> {
          :first_name=>account['info']['given_name'],
          :last_name=>account['info']['family_name'],
          :gender=>account['info']['gender'],
          :email=>account['info']['email']
        }
      }
    end
  end
end
