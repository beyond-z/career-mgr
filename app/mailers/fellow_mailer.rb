class FellowMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  
  def profile
    @token = params[:access_token]
    @fellow = @token.owner
    @unsubscriber = @fellow
    
    mail_subscribed(@fellow.receive_opportunities, to: @fellow.contact.email, subject: "Please update your Braven profile to receive job opportunities.")
  end
end
