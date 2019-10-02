class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth('GitHub')
  end

  def vkontakte
    # render json: request.env['omniauth.auth']
    oauth('vkontakte')
  end

  private

  def oauth(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Fail to authorize user!'
    end
  end
end
