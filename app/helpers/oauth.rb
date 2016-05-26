=begin
require 'net/http'
require 'iron_worker_ng'
require 'rest_client'

Linked4::App.helpers do
def auth_payload auth, additional={:type=>:new}
    {
      :uid          => auth['uid'],
      :name         => auth['name'],
      :provider     => auth['provider'],
      :email        => auth['user_info'].nil? ? '' : auth['user_info']['email'],
      :info         => JSON.parse(auth['extra'].to_json),
      :credentials  => JSON.parse(auth['credentials'].to_json)
    }.merge!(additional)
  end

  def perform_auth auth
    account = Auth::Provider.auth(auth, session[:user])

    setting = account[:user].setting

    if session[:user].nil?
      session[:user] = account[:user].id.to_s
      redir_to = setting.nil? ? "/me" : "/home"
    else
      Linked4::App.cache["user_#{session[:user]}_profiles"]=nil
      redir_to = account[:provider_status] == :new ? "/me" : "/home"
    end

    session[:registration_step] = setting.nil?

    if account[:provider_status] == :new && false
      iron_worker = IronWorkerNG::Client.new
      iron_worker.tasks.create("user_signup", {user_id: session[:user], data: auth})
    end

    session[:user_id] = @user

    redir_to
  end

end
=end
