# require 'nokogiri'
# require 'openuri'
require 'net/http'
require 'rubygems'
require 'json'
#require 'google/api_client'

Linked4::App.controllers do
  #FIXME replace for devise

  get :privacidade do
    haml :privacidade
  end

  get :termos do
    haml :termos
  end

  get :sobre do
    haml :sobre
  end

  post :signupnewsletter do
    email = params[:email]
    exists = Email.where(email: email).count==0
    Email.create({subscribed: true, email: email, code: SecureRandom.hex}) if exists
    redirect '/'
  end

  get "/unsubscribe/:email/:code" do
    email = params[:email]
    code = params[:code]
    Email.where(email: email, code: code).first.update(subscribed: false)
    redirect '/'
  end

  post :dailypost do
    #facebook
    #client-token 6b76964f4a2a51a7a988bf48d534678c
    #app-id 723248877786841
    #app-secret 516123dbe5c2acbc61e34ca4830fba1d

    by = ['morning','afternoon','evening']

    Koala.config.api_version = "v2.4"
    page_graph = Koala::Facebook::API.new('')
    page_graph.put_connections('1698395137050407', 'feed', :message => 'test of posting by api', :picture => '', :link => 'http://feed.brnews.co')

    #twitter
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ""
      config.consumer_secret     = ""
      config.access_token        = ""
      config.access_token_secret = ""
    end

    client.update("test of posting by api")
  end


=begin
  get :newsletter_seed do
    #add emails from facebook, linkedin, twitter and gplus

    #emails = ["fausto.alemao@gmail.com", "faustoct@hotmail.com", "tathi_rgt@hotmail.com", "tathiyagyu@hotmail.com", "ikedaivan@gmail.com", "ivan.ikeda@ig.com.br"]
    #emails.each do |email|
    #  exists = Email.where(email: email).count==0
    #  Email.create({subscribed: true, email: email}) if exists
    #end

    #emails = JSON.parse(IO.read('newsletter_seed_hotmail.json'))
    #emails.each do |email|
    #  exists = Email.where(email: email).count==0
    #  Email.create({subscribed: true, email: email}) if exists
    #end

    #emails = JSON.parse(IO.read('newsletter_seed_gmail.json'))
    #emails.each do |email|
    #  exists = Email.where(email: email).count==0
    #  Email.create({subscribed: true, email: email}) if exists
    #end

    #total = Email.count


    #line_num=0
    #text=File.open('newsletter_gmail.json').read
    #text.each_line do |line|
    #  line.gsub!(/\r/, "")
    #  line.gsub!(/\n/, "")
    #  emails << line
    #end

    #return {code:200, total: total}.to_json
  end
=end

  get :index do
    #if request.host.start_with?("feed.brnews.co") || request.host == "localhost"
    if request.host.start_with?("www.brnews.co")
      @highlights = getstories(0,3)
      feed(:index,[])
    elsif request.host.start_with?("landing.brnews.co") || request.host.start_with?("landing")
      haml "/landing/landing".to_sym
    #elsif request.host.start_with?("i.brnews.co")
    #  @appetizers = Story.find_by_sql("select s.topic_id, s.published, s.title, s.fb_from_name from ( select distinct(topic_id), max(published) as recent from stories group by topic_id ) as x inner join stories as s on s.topic_id = x.topic_id and s.published = x.recent and s.title is not null and s.topic_id<>11")
    #  haml :iindex
    elsif request.host.start_with?("ifeed.brnews.co") || request.host.start_with?("i.brnews.co")
        getstories(params[:page],5)
        haml :ifeed
    elsif request.host.start_with?("blog.brnews.co") || request.host.start_with?("blog")
        haml "/blog/blog".to_sym
    else
      @highlights = getstories(0,3)
      feed(:index,[])
      #feed(:index,getstories(0))
    end
  end

  get '/landing/:page' do
    page = params[:page]
    redirect '/' if (!request.host.start_with?("landing.brnews.co") && !request.host.start_with?("landing") || page.blank? || page=="landing")

    begin
      haml "/landing/#{page}".to_sym
    rescue Exception => e
      redirect '/'
    end
  end

  get '/blog/:page' do
    page = params[:page]
    redirect '/' if (!request.host.start_with?("blog.brnews.co") && !request.host.start_with?("blog") || page.blank? || page=="blog")

    begin
      haml "/blog/#{page}".to_sym
    rescue Exception => e
      redirect '/'
    end
  end

  get :feed do
    feed(:feed,[])
  end

  post :feed do
    json = JSON.parse(params[:json], :symbolize_names => true)
    token = session[:token]
    parts = token.split(":")
    session[:token] = "#{parts.first}:#{json[:topics].join(",")}:#{parts.last}"
    redirect '/'
  end

  get :test do
    #notify = params[:payload]
    x = params[:payload].split(',')
  end

  get :app do
    payload = params[:payload]

    unless payload.blank?
      begin
        _p = payload.split(',')
        notify = _p[0]
        registrationId = _p[1]
        type = _p[2]
        unless registrationId == "dev"
          SummaryPushNotification.create({notify: notify, registration_id: registrationId, action: type}) if (SummaryPushNotification.where(registration_id: registrationId).count==0)
        end
      rescue Exception => e
        puts "error parsing the payload from app request: #{request.path} => #{e}"
      end
    end

    if params[:topics].blank?
      token = session[:token]
      topic_ids = [2,3,4,5,6]
      ufa = cookies[:ufa].blank?

      if token.blank?
        cookies[:ufa] = 1
        token = "#{session.id}:#{topic_ids.join(",")}"
        session[:token] = token
      end

      parts = token.split(":")
      topic_ids = parts[1]

      {topics: topic_ids}.to_json
    else
      token = session[:token]

      if token.blank?
        token = "#{session.id}:#{params[:topics]}"
      end

      parts = token.split(":")
      topic_ids = params[:topics]
      token = "#{parts.first}:#{topic_ids}"
      session[:token] = token

      {code: 200, topics: topic_ids}.to_json
    end
  end

  get :cleanup do
    #clear caches!!!
    @@topics = []
    x=Redis.new(url: "")
    x.flushall
    x.quit
    cookies.clear
    session.clear
  end

  get :share_redir do
    haml :close
  end

  define_method :feed do |page,more,topic_ids=[]|
    #puts request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[az]{2}/).first
    #if cookies[:ufa].nil?
    #if token.nil?

    token = session[:token]
    #topic_ids = []
    ufa = cookies[:ufa].blank?

    #FIXME USING STATIC VARIABLE FOR SMALL NUMBER OF TOPICS and ONLY 1 SERVER!!!
    @@topics = []
    if @@topics.empty?
      topics=Topic.select(:id,:pt).where("name <> 'Blank' and id < 7")
      topics.each do |t|
        topic_ids << t[:id]
        @@topics<<{id: t[:id], name: t[:pt]}
      end
    end

    if token.nil?
      cookies[:ufa] = 1
      token = "#{session.id}:#{topic_ids.join(",")}:#{!params["app"].blank?}"
      session[:token] = token
    end

    parts = token.split(":")
    topic_ids = parts[1].split(",").map(&:to_i)
    app = parts[2]=="true"
    #result = JSON.parse(RestClient.post("http://brnews-feed.herokuapp.com/auth/#{token}/token",{}), :symbolize_names => true)

    haml page, locals: {
      app: app,
      topics: topic_ids,
      user_first_access: ufa,
      highlights: more,
      more: more}
  end

  define_method :getstories do |page=0,chunck=5|
    page = (page.blank? ? 0 : page).to_i
    chunck = 3
    @result = { stories: [], page: page, next:(page+1) }

    [2,3,4,5,6].each do |topic_id|
      @result[:stories].concat(Story.find_by_sql("select s.*, tpc.pt as topicn
      from stories s
      inner join topics tpc on tpc.id = s.topic_id
      where s.title is not null and tpc.id = #{topic_id}
      order by s.published desc limit #{chunck} offset (#{chunck} * #{page})"))

      #@result[:stories].concat( Story.select(:fb_full_pic,:topic_id, :qtitle, :published, :title, :fb_from_name, :fb_link).where("title is not null and topic_id=#{topic_id}").order('published desc').limit(chunck).offset(chunck * page) )
    end

    @result
  end

  define_method :feed_by_topic do |page,topic_id,chunck|
    page = (page.blank? ? 0 : page).to_i
    @result = { stories: [], page: page, next:(page+1) }
    @result[:stories].concat( Story.select(:fb_full_pic,:topic_id, :qtitle, :published, :title, :fb_from_name, :fb_link).where("title is not null and topic_id=#{topic_id}").order('published desc').limit(chunck).offset(chunck * page) )
    @result
  end

  define_method :topic_ids_from_token do
    token = session[:token]
    parts = token.split(":")
    topic_ids = parts[1].split(",").map(&:to_i)
    topic_ids
  end

  get '/topico/:name' do
    param = params[:name]
    topic_id = Topic.select(:id).where(pt: param).first
    redirect '/' if topic_id.blank?
    topic_id = topic_id[:id]

    feed(:index,{stories:feed_by_topic(0,topic_id,10), topic: param}, [topic_id])
  end

  get '/noticia/:title' do
    title = params[:title]

    story=Story.find_by_sql("select s.fb_full_pic,s.topic_id, s.published, s.title, s.fb_from_name, s.fb_link, s.qtitle, tpc.pt as topicn from stories s inner join topics tpc on tpc.id = s.topic_id where s.qtitle is not null and s.qtitle like '#{title}'").first

    recommended = Story.select(:fb_full_pic,:topic_id, :published, :title, :fb_from_name, :fb_link, :qtitle).where("title is not null and topic_id=#{story.topic_id}").order('published desc').limit(3).offset(0)

    #story = Story.select(:topic_id, :published, :title, :fb_from_name, :fb_link).where("qtitle is not null and qtitle=#{title}")
    #recommended = Story.select(:topic_id, :published, :title, :fb_from_name, :fb_link).where("title is not null and topic_id=#{topic_id}").order('published desc').limit(3).offset(0)

    haml :news, locals: {
      title: '',
      description: '',
      url: '',
      story: story,
      recommended: recommended
    }
  end

  get '/me/:page' do
    ids=nil
    begin
      ids = topic_ids_from_token
    rescue Exception => e
      #defensive programming check it later!
      #log? what else?
    end
    if ids.blank?
      ids=[2,3,4,5,6]
    end
    stories=Story.find_by_sql("select s.*, tpc.pt as topicn
    from stories s
    inner join topics tpc on tpc.id = s.topic_id
    where tpc.id in (#{ids.join(",")})
    order by s.published desc limit 7 offset (7 * #{params[:page]})")
    stories.to_json
  end

  get '/appetizers' do
    stories = Story.find_by_sql("select s.topic_id, s.published, s.title, s.fb_from_name
    from ( select distinct(topic_id), max(published) as recent from stories group by topic_id )
    as x inner join stories as s on s.topic_id = x.topic_id and s.published = x.recent and s.title is not null and s.topic_id<>11")
    stories.to_json
  end

  get '/mostrecent' do
  	queries = ""
    [2,3,4,5,6].each do |id|
      queries = queries + "(select s.topic_id, s.published, s.title, s.fb_from_name from stories s where s.title is not null and s.topic_id = #{ids[i]} order by s.published desc limit 5)"
  		queries = queries + "union" if id!=6
    end
  end

  get '/summary' do
    getstories.to_json
  end

  get '/resumao-do-dia' do
    posts_morning = PostDigest.select(:fb_full_pic, :source, :title, :url, :topic_name, :qtitle).where("period like 'morning'").order("topic_name asc")
    posts_afternoon = PostDigest.select(:fb_full_pic, :source, :title, :url, :topic_name, :qtitle).where("period like 'afternoon'").order("topic_name asc")
    haml :daily_digest, locals: {
      posts_morning: posts_morning,
      posts_afternoon: posts_afternoon
    }
  end

  get :dailydigest do
    posts_morning = PostDigest.find_by_sql("select p.fb_full_pic, p.url as fb_link, p.published, p.topic_name, p.qtitle, p.title, p.source as fb_from_name from post_digests as p where period like 'morning' order by topic_name asc")
    posts_afternoon = PostDigest.find_by_sql("select p.fb_full_pic, p.url as fb_link, p.published, p.topic_name, p.qtitle, p.title, p.source as fb_from_name from post_digests as p where period like 'afternoon' order by topic_name asc")
    {code:200 , data:{morning: posts_morning, afternoon:posts_afternoon}}.to_json
  end

=begin
  post '/summary-push-notification' do
    notify = params[:notify]
    registrationId = params[:registrationId]
    type = params[:type]

    payload

    SummaryPushNotification.create({notify: notify, registration_id: registrationId, action: type}) if (SummaryPushNotification.where(registration_id: registrationId).count==0)

    {code: 200}.to_json
  end
=end

=begin
  get '/dailydigest' do
    ids = [2,3,4,5,6]
    queries = ""

    var now = Now.
    var startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    //var today = startOfDay / 1000;
    //var tomorrow += (today + (3600 * 24));
    //var datetime = new Date(tomorrow*1000);

    startOfDay.setHours(10)
    var morning = startOfDay / 1000
    startOfDay.setHours(14)
    var afternoon = startOfDay / 1000
    startOfDay.setHours(18)
    var evening = startOfDay / 1000

    for(var i=0;i<ids.length;i++){
      //morning
      queries += ' (select s.topic_id, s.published, s.title, s.fb_from_name from stories s where s.title is not null and s.topic_id =' + ids[i] + ' and s.published < ' + morning + ' order by s.published desc limit 1) '
      queries += ' union '
      queries += ' (select s.topic_id, s.published, s.title, s.fb_from_name from stories s where s.title is not null and s.topic_id =' + ids[i] + ' and s.published > ' + morning + ' order by s.published asc limit 1) '
      queries += ' union '

      //afternoon
      queries += ' (select s.topic_id, s.published, s.title, s.fb_from_name from stories s where s.title is not null and s.topic_id =' + ids[i] + ' and s.published < ' + afternoon + ' order by s.published desc limit 1) '
      queries += ' union '
      queries += ' (select s.topic_id, s.published, s.title, s.fb_from_name from stories s where s.title is not null and s.topic_id =' + ids[i] + ' and s.published > ' + afternoon + ' order by s.published asc limit 1) '
      queries += ' union '

      //evening
      queries += ' (select s.topic_id, s.published, s.title, s.fb_from_name from stories s where s.title is not null and s.topic_id =' + ids[i] + ' and s.published < ' + evening + ' order by s.published desc limit 1) '
      queries += ' union '
      queries += ' (select s.topic_id, s.published, s.title, s.fb_from_name from stories s where s.title is not null and s.topic_id =' + ids[i] + ' and s.published > ' + evening + ' order by s.published asc limit 1) '

      if(i+1 < ids.length) queries += ' union '

  end
=end
end

#Topic.select(:id).joins(:user_topics).where("user_topics.topic_id in (#{topic_ids.join(",")}) and user_id=#{id}")
