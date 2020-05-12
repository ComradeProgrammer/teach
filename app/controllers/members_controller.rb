class MembersController < ApplicationController
  skip_before_action :require_login, only: [:get_all_info]

  def new

  end

  def create
    @errors = []
    puts "create======================"
    member_form = params[:member]
    puts member_form
    all_students = member_form['description']
    students = all_students.split("\r\n")
    num = 1
    not_move = 0
    students.each do |student|
      all_info = student.split(',')
      account = {:name => all_info[0],:username => all_info[1],:password => all_info[2],:email => all_info[3],:skip_confirmation =>  true}
      flag = 0
      User.all.each do |user|
        user_gitlab = users_service.get_user_info(user.gitlab_id)
        if user_gitlab['username'] == all_info[1]
          @errors = ["#{num}已经存在账号为#{all_info[1]}的用户"]
          flag = 1
          not_move = 1
        end
      end
      puts account
      if flag == 0
        member = members_service.new_member account
        puts "-------------------------------------"
        puts member
        model = User.new
        model.gitlab_id = member['id']
        model.username = account[:name]
        model.role = 'student'
        puts model.gitlab_id
        puts model.username
        model.save
      end
      num = num + 1
    end
    if not_move == 0
      redirect_to root_path
    end
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
  def users_service
    ::UsersService.new current_user
  end
end
