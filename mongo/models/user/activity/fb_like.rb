
class FbLike
  include Mongoid::Document
  include Rankable::Facebook

  field :account_id, type: String
  field :likes, type: Array

  index(account_id: 1)
    
  def process! token=nil
    unless likes.nil?
      @pages ||= rank token
      save!
      return @pages
    end
  end 
  
  def get
    likes
  end
  
  def self.get_by_user id
    FbLike.only(:likes).where(:account_id => id).first['likes']
  end
  
  def self.pages_ids_by_user_id id
    ids=[]
    lks=FbLike.only(:likes).where(:account_id => id).first['likes']
    lks.each do |lk|
      ids<<lk['id']
    end
    ids
  end  
end
