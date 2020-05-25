class HomeworksController < ApplicationController
  skip_before_action :require_login, only: [:get_all_info]

  def new

  end

  def create
    homework_form = params[:homework]
    #puts member_form
    name1 = homework_form['name']
    desc1 = homework_form['description']
    model = Homework.new
    model.name = name1
    model.description = desc1
    model.save
    puts model
    redirect_to classroom_homeworks_path
  end

  def index
    @all_member_info = User.all
    @homeworks = Homework.all

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
