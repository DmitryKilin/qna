class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth('GitHub')
  end

  def vkontakte
    # render json: request.env['omniauth.auth']
    oauth('vkontakte')
  end

  def demand_email
    render "devise/oauth_callbacks/demand_email"
  end

  def send_confirmation
    render inline: "<h1>Email sent to:</h1> <%= params[:email] %>"
  end

  private

  def oauth(provider)
    oauth = request.env['omniauth.auth']

    if !oauth['info'].has_key?('email') || oauth['info']['email'].blank?
      # session["devise.oauth_data"] = request.env["omniauth.auth"]
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
