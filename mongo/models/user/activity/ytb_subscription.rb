class YtbSubscription
  include Mongoid::Document
  include Rankable::Google_
  
  field :account_id, :type  => String
  field :subscriptions, :type  => Array

  index(account_id: 1)
  
  def process!
    unless subscriptions.nil?
      @subs ||= rank
      save!
      return @subs
    end
  end

  def get
    subscriptions
  end

  def self.get_by_user id
    YtbSubscription.only(:subscriptions).where(:account_id => id).first['subscriptions']
  end
  
  def self.channel_ids_by_user_id id
    ids=[]
    subs=YtbSubscription.only(:subscriptions).where(:account_id => id).first['subscriptions']
    subs.each do |sub|
      ids<<sub['snippet']['resourceId']['channelId']
    end
    ids
  end
end
