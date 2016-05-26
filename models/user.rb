class User < ActiveRecord::Base
  has_one :setting, autosave: true
  has_many :topics, through: :user_topics
  has_many :user_topics

  def self.find_by_provider provider, uid
    User.where("#{provider}_uid = '#{uid}'").first
  end

  def profile
    profile={:interests=>[]}

    topics.select(:pt).each do |t|
      profile[:interests] << {name: t[:pt]}
    end

    [:facebook, :linkedin, :google_oauth2, :instagram, :twitter].each do |p|
      account = self.attributes["#{p}_uid"]

      if account.nil?
        profile[p]={:pic=>nil}
        next
      end

      profile[p]={
        :info=> {
          :name=>self.attributes["#{p}_name"],
          :gender=>self.attributes["#{p}_gender"],
          :email=>self.attributes["#{p}_email"]
        }
      }

      token = self.attributes["#{p}_token"]

      case p
        when :facebook
          graph = Koala::Facebook::API.new(token)
          fields=graph.get_connection("me", "?fields=gender,picture")
          profile[p][:pic]=fields['picture']['data']['url']
          profile[p][:info][:gender]=fields['gender']
        when :linkedin
        when :google_oauth2
          client = Google::APIClient.new
          authorization = Signet::OAuth2::Client.new(
            :authorization_uri => 'https://accounts.google.com/o/oauth2/auth',
            :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
            :client_id => '',
            :client_secret => '',
            :redirect_uri => 'http://www.4linked.com/auth/google_oauth2/callback',
            :scope => 'profile,plus.login,email,https://www.googleapis.com/auth/youtube,https://www.googleapis.com/auth/youtube.readonly,https://www.googleapis.com/auth/plus.me'
          )
          authorization.access_token = token
          client.authorization = authorization
          fields=client.execute!(
            :api_method => client.discovered_api("plus").people.get,
            :parameters => {
              :userId => 'me'
            }
          )
          profile[p][:info][:gender]=fields.data.gender
          profile[p][:pic]=fields.data.image.url
        when :instagram
        when :twitter
      end unless account.nil?
    end

    profile
  end
end
