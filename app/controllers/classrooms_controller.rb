# frozen_string_literal: true
require 'date'

class ClassroomsController < ApplicationController
  @@dup_class = false
  @@shared = 0

  def counter
    @@shared
  end

  def counter_inc
    @@shared = @@shared + 1
  end

  # tool func: get id & name
  def get_all_classroom_id_and_name
    res = []
    Classroom.all.each do |classroom|
      gitlab_group_id = classroom.gitlab_group_id
      classname = groups_service.get_group(gitlab_group_id)['name']
      res.append({id: classroom.id, gitlab_group_id: gitlab_group_id, name: classname})
    end
    render json: res
  end

  # show index
  def index
    @errors = []
    @classrooms = []
    @all_classrooms = []
    user = User.find_by(gitlab_id: current_user.id)
    user.classrooms.all.each do |classroom|
      klass = groups_service.get_group(classroom.gitlab_group_id)
      statistics = groups_service.get_group_statistics(klass['id'])
      klass['id'] = classroom.id
      klass['own'] = true
      klass['commit_count'] = statistics[:commit_count]
      klass['repository_size'] = statistics[:repository_size]
      klass['storage_size'] = statistics[:storage_size]
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

    # find any duplicate class
    @@dup_class = false
    Classroom.all.each do |a_class|
      if a_class[:name] == @classroom[:name]
        # find it
        @@dup_class = true
        redirect_to new_classroom_path
        return
      end
    end
    classroom = owner.classrooms.new
    personal = !!@classroom.delete(:personal)
    pair = !!@classroom.delete(:pair)
    team = !!@classroom.delete(:team)
    # set up properties
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
    @classroom_id = params[:id]
    Classroom.all.each do |a_class|
      if a_class[:name] == @classroom[:name]
        # set duplicate class
        @@dup_class = true
        redirect_to edit_classrooms_path(@classroom_id)
        return
      end
    end
    classroom = Classroom.find(@classroom_id)
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
    classroom_id = params[:id]

    # if there is already a personal PUBLIC repo
    @has_personal_public = false
    @has_pair_public = false
    if AutoTestProject.find_by(:classroom_id => classroom_id, :test_type => 'personal', :is_public => 1).nil?
      @has_personal_public = false
    else
      @has_personal_public = true
    end

    if AutoTestProject.find_by(:classroom_id => classroom_id, :test_type => 'pair', :is_public => 1).nil?
      @has_pair_public = false
    else
      @has_pair_public = true
    end

    @classroom_record = Classroom.find(params[:id])
    unless @classroom_record.users.include? user
      render_403
      return
    end
    @classroom = groups_service.get_group @classroom_record.gitlab_group_id
    if @classroom_record.personal_project_subgroup_id
      @personal_projects = groups_service.get_projects @classroom_record.personal_project_subgroup_id
      # puts('>>>>>>>>>>>>>>>><<<<<<<<>>>>>>>><<<<<<<<')
      # puts(@personal_projects)
    end
    if @classroom_record.pair_project_subgroup_id
      @pair_projects = groups_service.get_projects @classroom_record.pair_project_subgroup_id
    end
    if @classroom_record.team_project_subgroup_id
      @team_projects = groups_service.get_projects @classroom_record.team_project_subgroup_id
      # puts('>>>>>>>>>>>>>subgroup')
      # puts(@classroom_record.team_project_subgroup_id)
      # puts(@team_projects)
      # puts('>>>>>>>>>>>>>')
      @team_projects.each do |team_project|
        # puts('>>>>>>>>>>>>>????')
        # puts(team_project)
        # puts('>>>>>>>>>>>>>????')
        record = TeamProject.find_by gitlab_id: team_project['id']
        # puts(record)
        # puts('>>>>>>>>>>>>>???xxxx?')
        # todo: fix bug with team status
        # team_project['states'] = record.team_states.collect(&:state).compact
      end
    end
    users = groups_service.get_members @classroom_record.gitlab_group_id
    # 所有 student
    # @students = users.find_all do |s|
    #   !@classroom_record.users.find_by(gitlab_id: s['id'], role: 'student').nil?
    # end
    all_classroom_member_id = []
    SelectClassroom.where(:classroom_id => classroom_id).each do |item|
      all_classroom_member_id.append(item.user_id)
    end
    #@students = SelectClassroom.where(:id => all_classroom_member_id, :role => 'student')
    @students = []
    User.where(:id => all_classroom_member_id, :role => 'student').each do |item|
      @students.append({:id => item.gitlab_id, :username => item.username,
                        :name => users_service.get_user_info(item.gitlab_id)['name']})
    end

    # 所有 teacher
    @teachers = users.find_all do |s|
      !@classroom_record.users.find_by(gitlab_id: s['id'], role: 'teacher').nil? || !@classroom_record.users.find_by(gitlab_id: s['id'], role: 'admin').nil?
    end
    @teachers.each do |t|
      t['is_me'] = t['id'] == current_user.id
    end
    # puts('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
    # puts(@teachers)

    @personal_homework_projects = []
    if @classroom_record.personal_project_subgroup_id
      @students.each do |student|
        # puts(student)
        # student_projects = groups_service.get_projects student[:username]
        # student_projects = groups_service.get_projects student['username']
        student_projects = groups_service.get_projects @classroom_record.gitlab_group_id
        # puts('>>>> Done')
        # puts(student_projects)
        person_homework_project = student_projects.find_all do |project|
          project[name] == AutoTestProjectsController.PERSONAL_HOMEWORK_PROJECT_NAME
        end
        if person_homework_project.length != 1
          # TODO: wrong dealing
        end
        # here delete the `@`, the `@` makes no sense
        person_homework_project.push({student: student, person_homework_project: person_homework_project.first})
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
    if user.role == 'teacher'
      add_group_member group_id, member
    end
    classroom.users << User.find_by(gitlab_id: current_user.id)
    redirect_to classrooms_path
  end

  # tool func: get id & name of stu
  def get_all_student_id_and_name
    # @classroom = Classroom.find(params[:classroom_id])

    # puts ('>>>>>>>>>>>>')
    # puts @classroom.gitlab_group_id
    # users = groups_service.get_members @classroom.gitlab_group_id
    # @students = users.find_all do |s|
    #   !@classroom_record.users.find_by(gitlab_id: s['id'], role: 'student').nil?
    # end

    @students_id_query = SelectClassroom.where(:classroom_id => params[:classroom_id])
    @students_id = []
    @students_id_query.each do |item|
      @students_id.append(item.user_id)
    end
    @students = User.where(:id => @students_id, :role => 'student')

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
    if user.role == 'teacher'
      remove_group_member group_id, current_user.id
    end
    redirect_to classrooms_path
  end

  def load_task_info
    @role = User.find_by(:gitlab_id => current_user.id).role
    @classroom_id = params[:id]

    @all_task_infos = []

    current_time = DateTime.now

    TaskPeriod.where(:classroom_id => @classroom_id).each do |item|
      task_steps_dict = []
      sub_judge = true
      sub_use_minus_one = "false"
      sub_use_max_plus_one = "false"
      TaskStep.order(step_date: :asc).where(:task_period_id => item.id).each do |sub_item|
        if sub_judge && sub_item.step_date > current_time
          sub_judge = false
          if task_steps_dict.length > 0
            task_steps_dict[-1][:selected] = "true"
          else
            sub_use_minus_one = "true"
          end
        end
        task_steps_dict.append(
          {
            :id => sub_item.id,
            :step_date => sub_item.step_date,
            :title => sub_item.title,
            :description => sub_item.description,
            :selected => "false"
          }
        )
      end
      if sub_judge
        sub_use_max_plus_one = "true"
      end
      is_selected = "false"
      if item.from_date <= current_time && item.to_date >= current_time
        is_selected = "true"
      end
      @all_task_infos.append(
        {
          :id => item.id,
          :title => item.title,
          :description => item.description,
          :from_date => item.from_date,
          :to_date => item.to_date,
          :tasksteps => task_steps_dict,
          :selected => is_selected,
          :sub_use_minus_one => sub_use_minus_one,
          :sub_use_max_plus_one => sub_use_max_plus_one
        }
      )
    end
  end

  def teaching_progress_index
    load_task_info
    @all_task_infos = @all_task_infos.to_json
    # puts '>>>>>>>>'
    # puts @all_task_infos
    render 'classrooms/teaching_progress_index'
  end

  def create_task_period
    # Format:
    # {"period"=>{"classroom_id"=>"3", "title"=>"test", "description"=>"this"},
    # "p"=>"2020-05-14 00:00:00", "e"=>"2020-06-09 00:00:00",
    # "controller"=>"classrooms", "action"=>"create_task_period", "id"=>"3"}
    period_info = params["period"]
    from_date = params["f"]
    to_date = params["t"]
    # puts period_info
    # puts from_date
    # puts to_date
    task_period = TaskPeriod.new
    task_period.from_date = from_date
    task_period.to_date = to_date
    task_period.title = period_info["title"]
    task_period.description = period_info["description"]
    task_period.classroom_id = period_info["classroom_id"]
    task_period.save

    # add two end points for each period
    task_step_0 = TaskStep.new
    task_step_0.step_date = from_date
    task_step_0.title = '开始'
    task_step_0.description = 'Start of a Period'
    task_step_0.task_period_id = task_period.id
    task_step_0.save

    task_step_1 = TaskStep.new
    task_step_1.step_date = to_date
    task_step_1.title = '结束'
    task_step_1.description = 'End of a Period'
    task_step_1.task_period_id = task_period.id
    task_step_1.save

    @role = User.find_by(:gitlab_id => current_user.id).role
    @classroom_id = params[:id]
    redirect_to teaching_progress_index_classroom_path
  end

  def create_task_step
    step_info = params["step"]
    step_date = params["f"]

    task_step_0 = TaskStep.new
    task_step_0.step_date = step_date
    task_step_0.title = step_info["title"]
    task_step_0.description = step_info["description"]
    task_step_0.task_period_id = step_info["task_period_id"]
    task_step_0.save

    @role = User.find_by(:gitlab_id => current_user.id).role
    @classroom_id = params[:id]
    redirect_to teaching_progress_index_classroom_path
  end

  def get_latest_step
    load_task_info
    task_steps = @all_task_infos[0][:tasksteps]
    task_steps.each do |item|
      if item[:selected] == "true"
        @latest_title = item[:title]
        break
      end
    end
    return_dict = {first: counter, title: @latest_title}
    self.counter_inc
    render json: return_dict
  end

  private

  # new team proj dir
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

  # new person proj dir
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

  # new pair proj dir
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

  def users_service
    ::UsersService.new current_user
  end

  def add_group_member(group_id, member)
    admin_api_post "groups/#{group_id}/members", member
  end

  def remove_group_member(group_id, user_id)
    admin_api_delete "groups/#{group_id}/members/#{user_id}"
  end
end
