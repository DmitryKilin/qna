class OauthConfirmationsController < ApplicationController

  def demand_email
    render "devise/oauth_confirmations/demand_email"
  end

  def send_confirmation
    # Generate a Authorization code and store a record in Authorization table
    # Put code here to generate and send confirmation email
    render inline: "<h1>Email sent to:</h1> <%= params[:email] %>"
  end
end