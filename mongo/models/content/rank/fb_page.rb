class FbPage
  include Mongoid::Document

  field :eligible, type: Boolean
  field :info, type: Hash
  field :page_id, type: String

  index(page_id: 1)
  
  def self.content id, token
    fbfeed =[]
    pages = FbPage.in(:page_id=>FbLike.pages_ids_by_user_id(id))

=begin
    unless pages.nil?
      graph = Koala::Facebook::API.new(token)
      pages.each_with_index do |page,index|
        #break if index==15 #FIXME REMOVE THIS. CREATE OTHER WAY TO GET THIS DATA!
        f = graph.get_connections("#{page['page_id']}", "feed?limit=1")
        next if skip?(f)
        fbfeed << {:from=>:facebook, :data=>f}
        #fbfeed << f
      end
    end

    puts fbfeed.to_json
=end
        
    result=[]
    unless pages.nil?
      graph = Koala::Facebook::API.new(token)
      slice = pages.each_slice(50).to_a
      
      slice.each do |part|
        result +=  graph.batch do |batch_api|
          part.each do |p|
            batch_api.get_connections("#{p['page_id']}", "feed?limit=1")
          end
        end
      end
    end
    
    result.each do |r|
      fbfeed << {:from=>:facebook, :data=>r} unless skip?(r)
    end

    fbfeed
  end
  
  def self.skip? f
    #FIXME check why sometimes get empty
    #TODO skipped content have to be used to decide about related content
    #puts f.first['from']['category'] unless f.empty?
    
    if f.class == Koala::Facebook::ClientError
      puts f.to_json
    end
    
    f.nil? || f.class == Koala::Facebook::ClientError || f.empty? || f.first['from']['category'] == "App page" || f.first['from']['category'] == "Musician/band" || 
      f.first['from']['category'] == "Cause" || f.first['from']['category'] == "Tv show" || f.first['from']['category'] == "Home decor" ||
      f.first['from']['category'] == "Athlete" || f.first['from']['category'] == "City" || f.first['from']['category'] == "Arts/humanities website" ||
      f.first['from']['category'] == "Radio station" || f.first['from']['category'] == "Entertainment website" || f.first['from']['category'] == "Computers/technology" ||
      f.first['from']['category'] == "Movie"   
  end
  
  private_class_method :skip?
end
