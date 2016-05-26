#require "pg"

namespace :pg do
  task :create => :environment do

=begin
  uri = URI.parse("postgres://vnlwtbjaepbqbw:LkPMzAEHhU-iHKIO2GOCTmJqKw@ec2-23-21-73-32.compute-1.amazonaws.com:5432/d893d13uq5ru7t")
  c = PG.connect( dbname: uri.path[1..-1], port: uri.port, host: uri.host, password: uri.password, user: uri.user )

  usersocial="CREATE TABLE user_social(
     id text PRIMARY KEY default uuid_generate_v4(),
     user_id text ,
     social_id text,
     social text
    );"
=end

=begin
    topics="CREATE TABLE topic(
       id text PRIMARY KEY default uuid_generate_v4(),
       name text,
       pt text,
       us text
      );"

    usertopics="CREATE TABLE user_topic(
       id text PRIMARY KEY default uuid_generate_v4(),
       user_id text ,
       topic_id text
      );"
=end

=begin
  stories="CREATE TABLE stories(
     id text PRIMARY KEY default uuid_generate_v4(),
     social_id text,
     social text,
     description text,
     title text,
     published int,
     fb_story text,
     fb_pic text,
     fb_icon text,
     fb_type text,
     fb_from_category text,
     fb_from_name text,
     fb_from_id text,
     fb_status_type text,
     fb_message text,
     fb_link text,
     fb_caption text,
     ytb_thumbnail text,
     ytb_channelId text,
     ytb_videoId text,
     ytb_channel_name text
    );"
=end

=begin
  userstories="CREATE TABLE user_stories(
     user_social_id text references user_social(id),
     story_id text references stories(id),
     PRIMARY KEY(user_social_id, story_id)
    );"
=end

    # this one works:
    #c.exec( "DROP TABLE IF EXISTS user_stories" )
    #c.exec( "DROP TABLE IF EXISTS user_social" )
    #c.exec( "DROP TABLE IF EXISTS stories" )
    #c.exec( "DROP TABLE IF EXISTS user_topic" )
    #c.exec( "DROP TABLE IF EXISTS topic" )
    #c.exec( 'drop extension if exists "uuid-ossp"' )


    #c.exec( 'create extension "uuid-ossp";' )
    #c.exec( usersocial )
    #c.exec( stories )
    #c.exec( userstories )
    #c.exec( topics )
    #c.exec( user_topic )

    #c.exec( "ALTER TABLE user_social ADD CONSTRAINT uk1 UNIQUE (user_id,social_id,social);" )

    #c.close
  end


  task :clear => :environment do
    conn = ActiveRecord::Base.connection
    tables = conn.tables
    tables.each do |table|
      puts "Deleting #{table}"
      conn.drop_table(table)
    end
  end
end
