class MembersController < ApplicationController
  skip_before_action :require_login, only: [:get_all_info]

  def new

  end

  def create
    puts "create======================"
    member_form = params[:member]
    puts member_form
    all_students = member_form['description']
    students = all_students.split("\r\n")
    students.each do |student|
      all_info = student.split(',')
      account = {"name" => all_info[0],"username" => all_info[1],"password" => all_info[2],"email" => all_info[3]}
      puts account
      members_service.new_member account
    end

    redirect_to root_path
  end

  def index
    @all_member_info = User.all
  end

  def get_all_info
    res = []
    User.all.each do |user|
      res.append({id:user.id, gitlab_id: user.gitlab_id, name: user.username,role: user.role})
    end
    render json: res
  end
  def members_service
    ::MembersService.new current_user
  end
end
