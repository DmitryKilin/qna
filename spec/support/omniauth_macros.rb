module OmniauthMacros
  def mock_auth_github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
        'provider' => 'github',
        'uid' => '123545',
        'info' => {
            'email' => 'mockuser@mail.me',
        }
    )
  end

  def mock_auth_vkontakte
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
        'provider' => 'vkontakte',
        'uid' => '123545',
        'info'=> {
            'email' => nil,
        }
    )
  end
end
