class YtbChannel
  include Mongoid::Document

  field :eligible, type: Boolean
  field :info, type: Hash
  field :channel_id, type: String
  index(channel_id: 1)

  def self.content id
    #ytbsubs = YtbChannel.in(:id=>JSON.parse(YtbSubscription.only(:_id).where(:account_id=>user['id']).first.id.to_json))
    channels=YtbChannel.in(:channel_id=>YtbSubscription.channel_ids_by_user_id(id))

    client = Google::APIClient.new(
      :key => '',
      :authorization => nil,
      :application_name => '4linked',
      :application_version => '1.0.0'
    )

    ytbfeed=[]

=begin
    channels.each_with_index do |channel,index|
      #break if index==15 #FIXME REMOVE THIS. CREATE OTHER WAY TO GET THIS DATA!
      videos=client.execute!(
          :api_method => client.discovered_api("youtube", "v3").playlist_items.list,
          :parameters => {
            :playlistId => channel['info']['uploads'],
            :part => 'snippet',
            :maxResults=>1})
      ytbfeed << {:from=>:google_oauth2, :data=>videos.data.items.first.snippet} unless videos.data.items.first.nil?
      #ytbfeed << videos.data.items.first.snippet unless videos.data.items.first.nil?
    end
=end

    batch = Google::APIClient::BatchRequest.new do |video|
      ytbfeed << {:from=>:google_oauth2, :data=>video.data.items.first.snippet} unless video.data.items.first.nil?
    end

    channels.each_with_index do |channel,index|
      batch.add({
        :api_method => client.discovered_api("youtube", "v3").playlist_items.list,
          :parameters => {
            :playlistId => channel['info']['uploads'],
            :part => 'snippet',
            :maxResults=>1}
      })
    end

    client.execute!(batch)

    ytbfeed
  end
end
