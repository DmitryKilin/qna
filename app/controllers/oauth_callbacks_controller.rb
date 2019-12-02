class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth('GitHub')
  end

  def vkontakte
    oauth('vkontakte')
  end

  private

  def oauth(provider)
  oauth = request.env['omniauth.auth']

    if !oauth['info'].has_key?('email') || oauth['info']['email'].blank?
      redirect_to demand_email_path
      return
    end

    @user = User.find_for_oauth(oauth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Fail to authorize user!'
    end
  end
end
