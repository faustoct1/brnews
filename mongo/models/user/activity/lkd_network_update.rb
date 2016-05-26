
class LkdNetworkUpdate
  include Mongoid::Document
  include Rankable::Linkedin
  
  field :account_id, type: String
  field :network_updates, type: Hash

  index(account_id: 1)
    
  def self.build user
    lkdfeed = []
    network_updates = LkdNetworkUpdate.where(:account_id=>user['id']).first
    unless network_updates.nil?
        lkdfeed = network_updates.network_updates['all']
    end 
    lkdfeed
  end
end

# threshold: number of page likes, number of results on google, keywords, black list, category weight/relevance, created-time 