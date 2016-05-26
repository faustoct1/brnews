  require 'rubygems'

#require 'json'
#require 'google/api_client'

module Auth
  module Provider
    def self.auth(data,user_id=nil)
      user = User.find_by_user_id(user_id)
      if user.nil?
        user = User.new(user_id: user_id)
        signup(user,data)
      	return {user: user, provider_type: :new}
      else
      	user = User.where(user_id: user_id).first
        type = nil
      	if user.accounts[data["provider"]].nil?
          type = :new
      	  auth_more(user,data)
      	end
        return {user: user, provider_type: type}
      end
    end

    def self.auth_more(account,data)
      signup(account, data)
      account
    end

    def self.signup account, auth
      account.accounts[auth['provider']] = {
        :uid          => auth['uid'],
        :name         => auth['name'],
        :provider     => auth['provider'],
        :email        => auth['email'],
        :info         => auth['info'],
        :credentials  => auth['credentials'],
        :id           => account.id.to_s
      }

      account.save
    end

    def self.scrapy_provider id, provider
      account = User.find_by_id id
      model = Auth::Provider::const_get("#{provider.capitalize}Api").new
      model.build account.accounts[provider]
    end

    def build auth
      raise "Implement me, Thanks!"
    end

    class FacebookApi
      include Auth::Provider

      def build account
        token=account[:credentials]['token']
        graph = Koala::Facebook::API.new(token)
        likes = graph.get_connections("me", "likes?limit=999")
        result = []
        until likes.nil? do
          result += likes
          likes = likes.next_page
          #break #FIXME REMOVE BREAK FOR GATHER ALL DATA FROM USER. But it is too slow!
        end

        FbLike.new(:account_id=>account[:id],:likes=>JSON.parse(result.to_json)).process! token
      end
    end

    class Google_oauth2Api
      include Auth::Provider

      def build account
        client = Google::APIClient.new

        #'https://accounts.google.com/o/oauth2/token',
        #'https://accounts.google.com/o/oauth2/auth',
        # :authorization_uri => credentials.authorization_uri,
        # :token_credential_uri => credentials.token_credential_uri,
        #:token => account.credentials.token,
        authorization = Signet::OAuth2::Client.new(
          :authorization_uri => '',
          :token_credential_uri => '',
          :client_id => '',
          :client_secret => '',
          :redirect_uri => '',
          :scope => 'profile,plus.login,email,https://www.googleapis.com/auth/youtube,https://www.googleapis.com/auth/youtube.readonly,https://www.googleapis.com/auth/plus.me'
        )

        authorization.access_token = account[:credentials]['token']
        #authorization.expires_in = (Time.parse(account.credentials.expires_at) - Time.now).ceil

        #if authorization.expired?
        #  authorization.fetch_access_token!
          #save(credentialsFile) # save token on document!
        #end

        client.authorization = authorization
        first = true
        subscriptions=client.execute!(
          :api_method => client.discovered_api("youtube", "v3").subscriptions.list,
          :parameters => {
            :mine => true,
            :part => 'snippet',
            :maxResults=>50
          }
        )

        result = []
        result += subscriptions.data.items

        until subscriptions.next_page_token.nil?
          subscriptions=client.execute!(subscriptions.next_page)
          result += subscriptions.data.items
        end

        YtbSubscription.new(:account_id=>account[:id],:subscriptions=>JSON.parse(result.to_json)).process! unless result.empty?
      end
    end

    class LinkedinApi
      include Auth::Provider

      def build account
        client = LinkedIn::Client.new(account['info']['access_token']['consumer']['key'], account['info']['access_token']['consumer']['secret'])
        client.authorize_from_access(account['info']['access_token']['token'], account['info']['access_token']['secret'])
        LkdNetworkUpdate.new(:account_id=>account[:id], :network_updates=>JSON.parse(client.network_updates.to_json)).process!
        #TODO more from here
      end
    end

    class TwitterApi
      include Auth::Provider

      def build account
        client = Twitter::REST::Client.new do |config|
          config.consumer_key        = account['info']['access_token']['consumer']['key']
          config.consumer_secret     = account['info']['access_token']['consumer']['secret']
          config.access_token        = account['info']['access_token']['token']
          config.access_token_secret = account['info']['access_token']['secret']
        end

        TwtFollowing.new(:account_id=>account[:id],:following=>JSON.parse(client.following.to_json)).process!
      end
    end

    class InstagramApi
      include Auth::Provider

      def build account
        client = Instagram.client(:access_token => account['credentials']['token'])
        InstFollowing.new(:account_id=>account[:id],:following=>JSON.parse(client.user_follows.to_json)).process!
      end
    end
  end
end
