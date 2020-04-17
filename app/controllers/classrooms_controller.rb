# frozen_string_literal: true

class ClassroomsController < ApplicationController
  @@dup_class = false

  def get_all_classroom_id_and_name
    res = []
    Classroom.all.each do |classroom|
      gitlab_group_id = classroom.gitlab_group_id
      classname = groups_service.get_group(gitlab_group_id)['name']
      res.append({id: classroom.id, gitlab_group_id: gitlab_group_id, name: classname})
    end
    render json: res
  end

  def index
    @errors = []
    @classrooms = []
    @all_classrooms = []
    user = User.find_by(gitlab_id: current_user.id)
    user.classrooms.all.each do |classroom|
      klass = groups_service.get_group(classroom.gitlab_group_id)
      klass['id'] = classroom.id
      klass['own'] = true
      @classrooms << klass
      @all_classrooms << klass
    end

    Classroom.all.each do |classroom|
      next if @classrooms.find { |c| c['id'] == classroom.id }
      klass = groups_service.get_group(classroom.gitlab_group_id)
      klass['id'] = classroom.id
      klass['own'] = false
      @all_classrooms << klass
    end
  end

  def new
    @errors = []
    if @@dup_class
      @errors = ['名称重复']
      @@dup_class = false
    end
    @classroom = Classroom.new
  end

  def create
    owner = User.find_by(gitlab_id: current_user.id)
    @classroom = params[:classroom]
    @@dup_class = false
    Classroom.all.each do |a_class|
      if a_class[:name] == @classroom[:name]
        @@dup_class = true
        redirect_to new_classroom_path
        return
      end
    end
    classroom = owner.classrooms.new
    personal = !!@classroom.delete(:personal)
    pair = !!@classroom.delete(:pair)
    team = !!@classroom.delete(:team)
    @classroom['visibility'] = 'public'
    @classroom['request_access_enabled'] = true
    group = groups_service.new_group @classroom
    classroom.gitlab_group_id = group['id']
    if team
      # 团队项目 subgroup
      team_project_dir = new_team_project_dir(group['id'])
      team_project_group = groups_service.new_group(team_project_dir)
      classroom.team_project_subgroup_id = team_project_group['id']
    end
    if personal
      # 个人项目 subgroup
      personal_project_dir = new_personal_project_dir(group['id'])
      personal_project_group = groups_service.new_group(personal_project_dir)
      classroom.personal_project_subgroup_id = personal_project_group['id']
    end
    if pair
      # 结对项目 subgroup
      pair_project_dir = new_pair_project_dir(group['id'])
      pair_project_group = groups_service.new_group(pair_project_dir)
      classroom.pair_project_subgroup_id = pair_project_group['id']
    end
    classroom.save
    classroom.users << owner
    redirect_to classrooms_path
  rescue RestClient::BadRequest => e
    @classroom['personal'] = personal
    @classroom['pair'] = pair
    @classroom['team'] = team
    @errors = ['名称或地址包含非法字符或已被占用']
    render 'new'
  end

  def edit
    @errors = []
    if @@dup_class
      @errors = ['名称重复']
      @@dup_class = false
    end
    @classroom = Classroom.new
    @classroom_id = params[:id]
  end
  
  def update
    @classroom = params[:classroom]
    @classroom_id = params[:classroom_id]

    Classroom.all.each do |a_class|
      if a_class[:name] == @classroom[:name]
        @@dup_class = true
        redirect_to edit_classrooms_path(@classroom_id)
        return
      end
    end

    classroom = Classroom.find_by(@classroom_id)
    groups_service.update_group(classroom.gitlab_group_id, @classroom)
    redirect_to classrooms_path
  end

  def destroy
    @classroom = Classroom.find(params[:id])
    @classroom.destroy
    groups_service.delete_group @classroom.gitlab_group_id
    redirect_to classrooms_path
  end

  def show
    user = User.find_by(gitlab_id: current_user.id)
    @classroom_record = Classroom.find(params[:id])
    unless @classroom_record.users.include? user
      render_403
      return
    end
    @classroom = groups_service.get_group @classroom_record.gitlab_group_id
    if @classroom_record.personal_project_subgroup_id
      @personal_projects = groups_service.get_projects @classroom_record.personal_project_subgroup_id
    end
    if @classroom_record.pair_project_subgroup_id
      @pair_projects = groups_service.get_projects @classroom_record.pair_project_subgroup_id
    end
    if @classroom_record.team_project_subgroup_id
      @team_projects = groups_service.get_projects @classroom_record.team_project_subgroup_id
      @team_projects.each do |team_project|
        record = TeamProject.find_by gitlab_id: team_project['id']
        team_project['states'] = record.team_states.collect(&:state).compact
      end
    end
    users = groups_service.get_members @classroom_record.gitlab_group_id
    # 所有 student
    @students = users.find_all do |s|
      !@classroom_record.users.find_by(gitlab_id: s['id'], role: 'student').nil?
    end
    # 所有 teacher
    @teachers = users.find_all do |s|
      !@classroom_record.users.find_by(gitlab_id: s['id'], role: 'teacher').nil?
    end
    @teachers.each do |t|
      t['is_me'] = t['id'] == current_user.id
    end

    @personal_homework_projects = []
    if @classroom_record.personal_project_subgroup_id
      @student.each |student| do
        student_projects = groups_service.get_projects student[:username]
        person_homework_project = student_projects.find_all do |project|
          project[name] == AutoTestProjectsController.PERSONAL_HOMEWORK_PROJECT_NAME
        end
        if person_homework_project.length != 1
          # TODO: wrong dealing
        end
        @person_homework_project.push {student: student, person_homework_project: person_homework_project.first}
      end
    end
  end

  # current user join classroom
  def join
    classroom_id = params[:id]
    classroom = Classroom.find(classroom_id)
    group_id = classroom.gitlab_group_id
    user = User.find_by(gitlab_id: current_user.id)
    access = user.role == 'teacher' ? 50 : 20
    member = {
      user_id: current_user.id,
      access_level: access
    }
    add_group_member group_id, member
    classroom.users << User.find_by(gitlab_id: current_user.id)
    redirect_to classrooms_path
  end

  def get_all_student_id_and_name
    @classroom = Classroom.find(params[:classroom_id])
    users = groups_service.get_members @classroom.gitlab_group_id
    @students = users.find_all do |s|
      !@classroom_record.users.find_by(gitlab_id: s['id'], role: 'student').nil?
    end
    res = []
    @students.all.each do |student|
      res.append({id: student.id, gitlab_id: student.gitlab_id, name: student.username, role: student.role})
    end
    render json: res
  end

  # current user exit classroom
  def exit
    classroom_id = params[:id]
    classroom = Classroom.find(classroom_id)
    user = User.find_by(gitlab_id: current_user.id)
    sc = SelectClassroom.find_by(user_id: user.id, classroom_id: classroom_id)
    sc.destroy

    group_id = classroom.gitlab_group_id
    if user.role == 'teacher'
      teachers = classroom.users.where(role: 'teacher')
      if teachers.count.zero?
        groups_service.delete_group group_id
        classroom.destroy
        redirect_to classrooms_path
        return
      end
    end
    remove_group_member group_id, current_user.id
    redirect_to classrooms_path
  end

  private

  def new_team_project_dir(parent_id)
    team_project_dir = {}
    team_project_dir['name'] = '团队项目'
    team_project_dir['path'] = 'team-projects'
    team_project_dir['description'] = '团队项目文件夹，同学们在这里创建自己的团队项目'
    team_project_dir['visibility'] = 'public'
    team_project_dir['request_access_enabled'] = true
    team_project_dir['parent_id'] = parent_id
    team_project_dir
  end

  def new_personal_project_dir(parent_id)
    team_project_dir = {}
    team_project_dir['name'] = '个人项目'
    team_project_dir['path'] = 'personal-projects'
    team_project_dir['description'] = '个人项目文件夹，同学们在这里 fork 个人项目作业'
    team_project_dir['visibility'] = 'public'
    team_project_dir['request_access_enabled'] = true
    team_project_dir['parent_id'] = parent_id
    team_project_dir
  end

  def new_pair_project_dir(parent_id)
    team_project_dir = {}
    team_project_dir['name'] = '结对项目'
    team_project_dir['path'] = 'pair-projects'
    team_project_dir['description'] = '结对项目文件夹，同学们在这里 fork 结对项目作业'
    team_project_dir['visibility'] = 'public'
    team_project_dir['request_access_enabled'] = true
    team_project_dir['parent_id'] = parent_id
    team_project_dir
  end

  def groups_service
    ::GroupsService.new current_user
  end

  def add_group_member(group_id, member)
    admin_api_post "groups/#{group_id}/members", member
  end

  def remove_group_member(group_id, user_id)
    admin_api_delete "groups/#{group_id}/members/#{user_id}"
  end
end

