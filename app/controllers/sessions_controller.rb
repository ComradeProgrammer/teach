# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:login]
  before_action :login_redirect, only: [:login]

  def logout
    user_logout
    session[:user_token] = nil
    redirect_to root_url
  end

  def login
    access_code = params['code']
    user_type = params['state']
    return unless access_code

    access_token = user_auth access_code
    if access_token
      session[:type] = user_type
      log_in access_token
      unless create_user
        render_403
        return
      end
      redirect_to root_url
    else
      # return 403
      render_403
    end
  end

  private

  def login_redirect
    redirect_to root_url if logged_in?
  end
  
  def create_user
    gitlab_user_id = session[:user_id]
    type = session[:type]
    username = session[:username]
    user = User.find_by(gitlab_id: gitlab_user_id)
    # 暂时允许老师从学生登录入口登录
    return true if user && user.role == 'teacher'
    return false if user && user.role != type
    User.create(gitlab_id: gitlab_user_id, role: type, username: username) unless user
    true
  end
end
