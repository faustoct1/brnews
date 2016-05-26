#require 'bundle/bundler/setup'

require 'padrino-core'
require 'active_record'
require 'json'
require 'mail'
require "./config/database"
require "./models/email"

puts "start"

type_mail = ARGV[0]
#current_issue = 1
#number_of_users= 350 #(350,350)
#page= 0
email_list = Email.where("email not in (?) and subscribed = true",['faustoct@hotmail.com']).order(:id).offset(0).limit(600)
#email_list = Email.where("email in (?) and subscribed = true",['fausto.alemao@gmail.com'])
puts "#{email_list.count} emails read"

class GrabException < Exception
end

def _send email,html
  return
  begin
    Mail.deliver do
      to "#{email.email}"
      from 'newsletter@brnews.com'
      subject "brNEWS Newsletter #2"

      #body "#{email}"

      _html = html.gsub('#{code}',email.code).gsub('#{email}',email.email)

      text_part do
        body _html
      end

      html_part do
        content_type 'text/html; charset=UTF-8'
        body _html
      end
    end
  rescue Exception=>e
    puts "[#{email.email} : #{e} : #{e.message}]"
  end
end

Mail.defaults do
  delivery_method :smtp, {
    :address => 'smtp.sendgrid.net',
    :port => '587',
    :domain => 'heroku.com',
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :authentication => :plain,
    :enable_starttls_auto => true
  }
end

#content_type 'text/html; charset=UTF-8'

if type_mail=='newsletter'
  html = File.open("workers/newsletter2.html").read
  email_list.each do |email|
    _send(email,html)
  end
elsif type_email == 'digest'
end
