

class User
  include Mongoid::Document

  field :user_id, type: Integer
  field :provider, type: String
  field :uid, type: String
  field :name, type: String
  field :email, type: String
  field :credentials, type: Hash
  field :info, type: Hash
  field :accounts, type: Hash, default: {}
  field :config, type: Hash, default: {}
  index(user_id: 1)
  index(uid: 1)

  def self.find_by_id(id)
    User.find(id) rescue nil
  end

  def self.find_by_user_id(id)
    User.where(user_id: id).first
  end

  def self.find_by_provider provider, uid
    User.where( :"accounts.#{provider}".ne => nil, :"accounts.#{provider}.uid" => uid ).first
  end

  def provide? p
      provider==p.to_s || accounts.key?(p.to_s)
  end

  def feeds
    @feeds ||= FeedLookup.new.run(self)
  end

  def ytb_subscriptions
    YtbSubscription.get_by_user id
  end

  def ytb_subscriptions_name
   YtbSubscription.only('subscriptions.snippet.title').where(:account_id => id).first['subscriptions']
  end

  def fb_likes
    FbLike.get_by_user id
  end

  def fb_likes_name
    FbLike.only('likes.name').where(:account_id => id).first['likes']
  end

  def profile
    #FbLike.only('likes.name').where(:account_id => id).first['likes']
    @profile ||= ProfileLookup.new.run(self)
  end
end
