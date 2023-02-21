class ApplicationController < ActionController::Base

    helper_method :current_user,:logged_in?, :auth_token 
    def login(user)
        session[:session_token] = user.reset_session_token! 
    end 

    def current_user 
        @current_user ||= User.find_by(session_token:session[:session_token])
    end 

    def logout!
        session[:session_token] = nil 
        current_user.reset_session_token! if logged_in? 
        @current_user = nil 
    end 

    def logged_in?
        !!current_user 
    end 

    def require_logged_in
        redirect_to new_session_url unless logged_in? 
    end 

    def require_logged_out 
        redirect_to users_url if logged_in? 
    end 

    def auth_token 
        "<input 
        type = 'hidden'
        name = 'authenticity_token' 
        value = '#{form_authenticity_token}'>".html_safe 
    end 
end
