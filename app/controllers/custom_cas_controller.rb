require 'casclient'

class CustomCasController < ApplicationController
  def index
    service = URI.encode("#{request.base_url}/users/service")
    redirect_to "#{Rails.application.secrets.nlu_sso_url}login?service=#{service}"
  end

  def service
    is_nlu = true
    casclient = CASClient::Client.new(:cas_base_url => is_nlu ?
      Rails.application.secrets.nlu_sso_url : Rails.application.secrets.sso_url)
    st = CASClient::ServiceTicket.new(params[:ticket], "#{request.base_url}/users/service")
    casclient.validate_service_ticket(st)
    if st.is_valid?
      sso_user = st.user
      if is_nlu && !st.extra_attributes["EmployeeNumber"].nil?
        sso_user = "#{st.extra_attributes["EmployeeNumber"]}@nlu.edu"
      end
      user = User.where(:email => sso_user).first
      user ||= User.create(:email => sso_user)
      sign_in('user', user)

      redirect_to(follow_redirect || root_path)
    else
      Rails.logger.info("not valid #{is_nlu} #{st.failure_code}")
      render plain: "Your login was not valid. Please try again."
    end
  end
end
