require 'uri'

Devise::CasSessionsController.class_eval do
  def new
    if session[:sso]
      service_path = (session[:sso] == Rails.application.secrets.sso_url) ? "service_braven" : "service"
      service = URI.encode("#{request.base_url}/users/#{service_path}", /[^\-_!~*'()a-zA-Z\d;?@&=+$,\[\]]/)
      sso_url = session.delete(:sso)

      url="#{sso_url}login?service=#{service}"
      Rails.logger.info("SSO_URL: #{url}")

      redirect_to url
    else
      redirect_to login_path
    end
  end
end
