module OmniauthInitializer
  def self.registered(app)
    app.use OmniAuth::Builder do
      provider :developer unless Padrino.env == :production
      provider :facebook, '524656474329640', '',:scope=>"public_profile,email,user_friends,user_about_me,user_likes"
      provider :google_oauth2, '', '', {:scope=>"profile,plus.login,email,https://www.googleapis.com/auth/youtube,https://www.googleapis.com/auth/youtube.readonly"}
      provider :linkedin, '', '', :scope => 'rw_company_admin rw_nus r_emailaddress w_messages r_network r_basicprofile rw_groups r_fullprofile r_contactinfo'
      provider :instagram, '', ''
      provider :twitter, '', ''
    end
  end
end

=begin
https://www.googleapis.com/auth/youtube Manage your YouTube account.
https://www.googleapis.com/auth/youtube.readonly  View your YouTube account.
https://www.googleapis.com/auth/youtube.upload  Upload YouTube videos and manage your YouTube videos.
https://www.googleapis.com/auth/youtubepartner-channel-audit
=end
