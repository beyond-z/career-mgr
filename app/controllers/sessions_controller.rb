class SessionsController < Devise::SessionsController
  def new
    if params['plain_login']
      super
    else
      # we don't need this to appear on the site since the SSO
      # redirect prompts them to log in via the separate server.
      # they'd see it twice if we didn't clear!
      flash[:error] = nil
      redirect_to new_sso_user_session_path
    end
  end
  
  def destroy
    url = if session[:service_signout_url]
      session[:service_signout_url]
    else
      service = URI.encode("#{request.base_url}/users/service_braven", /[^\-_!~*'()a-zA-Z\d;?@&=+$,\[\]]/)
      "#{Rails.application.secrets.sso_url}logout?service=#{service}"
    end
    
    reset_session

    redirect_to url
  end
end
