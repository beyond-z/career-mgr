class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:health_check, :login, :sso, :service_braven, :service_nlu]
  
  def welcome
    case current_user.role
    when :admin
      redirect_to admin_home_welcome_path
    when :fellow
      redirect_to fellow_home_welcome_path
    end
  end
  
  def health_check
    User.count
    render inline: '200 OK'
  end
  
  def login
    flash[:alert] = nil
  end
  
  def sso
    url = nil
    if params[:id] == 'nlu'
      service = URI.encode("#{request.base_url}/users/service", /[^\-_!~*'()a-zA-Z\d;?@&=+$,\[\]]/)
      url="#{Rails.application.secrets.nlu_sso_url}login?service=#{service}"
    else
      service = URI.encode("#{request.base_url}/users/service_braven", /[^\-_!~*'()a-zA-Z\d;?@&=+$,\[\]]/)
      url="#{Rails.application.secrets.sso_url}login?service=#{service}"
    end

    Rails.logger.info("SSO_URL: #{url}")
    redirect_to url
    #redirect_to session.delete(:last)
  end

  def service_nlu
    casclient = CASClient::Client.new(:cas_base_url => Rails.application.secrets.nlu_sso_url)
    st = CASClient::ServiceTicket.new(params[:ticket], "#{request.base_url}/users/service")
    casclient.validate_service_ticket(st)
    if st.is_valid?
      sso_user = st.user
      if !st.extra_attributes["EmployeeNumber"].nil?
        sso_user = "#{st.extra_attributes["EmployeeNumber"]}@nlu.edu"
      end

      log_in_completion(sso_user)
    else
      Rails.logger.info("not valid NLU #{st.failure_code}")
      render plain: "Your login was not valid. Please try again."
    end
  end

  def service_braven
    casclient = CASClient::Client.new(:cas_base_url => Rails.application.secrets.sso_url)
    st = CASClient::ServiceTicket.new(params[:ticket], "#{request.base_url}/users/service_braven")
    casclient.validate_service_ticket(st)
    if st.is_valid?
      log_in_completion(st.user)
    else
      Rails.logger.info("not valid Braven #{st.failure_code}")
      render plain: "Your login was not valid. Please try again."
    end
  end

  def log_in_completion(sso_user)
    user = User.where(:email => sso_user.downcase).first
    user ||= User.create(:email => sso_user.downcase)
    sign_in user

    redirect_to(session.delete(:last) || root_path)
  end
end
