class ApplicationController < ActionController::Base
  before_filter :require_user
  before_filter :check_permission

  protect_from_forgery

  helper_method :current_user_session, :current_user

  private
  def check_permission
    if current_user
      permission = self.class.to_s.underscore.split("_").first + "_permission"
      if current_user.attributes.map{|k,v| k}.include?(permission)
        redirect_to root_path unless current_user.attributes[permission]
      end
    end
  end

    def current_user_session
      logger.debug "ApplicationController::current_user_session"
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      logger.debug "ApplicationController::current_user"
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def require_user
      logger.debug "ApplicationController::require_user"
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      logger.debug "ApplicationController::require_no_user"
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
end
