require 'json'

=begin
This controller contains methods about interacting with runner like
creating auto test points, start auto test task and get result, etc.
We use auto-test-runner API (defined in `services/auto_test_runners_service`)
to make interaction with runner.
=end

class AutoTestProjectsController < ApplicationController
  PERSONAL_HOMEWORK_PROJECT_NAME = "student_personal_project_"

  @@project_type = 'personal'
  @@errors_save = []

  @@creating_private_personal_project = false
  @@total_students_num = 0
  @@private_personal_project_progress = 0

  def show
  end

  # new auto test project
  def new
    @errors = []
    if @@errors_save.size > 0
      @errors = @@errors_save
      @@errors_save = []
    end
    @classroom_id = params[:classroom_id]
    classroom = Classroom.find_by(id: @classroom_id)
    @classroom_name = groups_service.get_group(classroom.gitlab_group_id)['path']
    @type = params[:type]
    @@project_type = params[:type]
    @is_public = 'yes'
    if params[:type] == 'personal'
      @title = '创建个人项目'
      @projects_name = 'personal-projects'
      @auto_test_project = AutoTestProject.new('personal')
    elsif params[:type] == 'personal-batch'
      redirect_to batch_create_classroom_auto_test_projects_path classroom_id: params[:classroom_id]
    elsif params[:type] == 'pair'
      @title = '创建结对项目'
      @projects_name = 'pair-projects'
      @auto_test_project = AutoTestProject.new('pair')
      @is_public = params[:is_public]
    end
  end

  def new_pair_projects_batch
    # todo: complete new func and pages
    @errors = []
    if @@errors_save.size > 0
      @errors = @@errors_save
      @@errors_save = []
    end
    @classroom_id = params[:classroom_id]
    classroom = Classroom.find_by(id: @classroom_id)
    @classroom_name = groups_service.get_group(classroom.gitlab_group_id)['path']
    @type = params[:type]
    @@project_type = params[:type]
    @is_public = 'yes'
    @title = '批量创建结对项目'
    @projects_name = 'pair-projects'
    @auto_test_project = AutoTestProject.new('pair')
    # @is_public = params[:is_public]
  end

  # todo: test to see if buggy
  def get_all_member_id(query)
    all_students_gitlab_id_in_class = []
    all_teachers_gitlab_id_in_class = []
    query.each do |item|
      tmp = User.find(item.user_id)
      if tmp.role == 'student'
        all_students_gitlab_id_in_class.append(tmp.gitlab_id)
      else
        all_teachers_gitlab_id_in_class.append(tmp.gitlab_id)
      end
    end
    return [all_students_gitlab_id_in_class, all_teachers_gitlab_id_in_class]
  end

  def validate_runner
    path = params[:path]
    # p '#######'
    # p path
    begin
      res = auto_test_runners_service.validate_runner path
    rescue Exception => e
      p e
      raise e
    end
    # p res
    render json: res
  end

  # todo: test to see if buggy
  def create_pair_project(id1, id2)
    @auto_test_project = AutoTestProject.new('pair')
    @classroom_students_query = SelectClassroom.where(:classroom_id => params[:classroom_id])
    @all_students_gitlab_id_in_class = get_all_member_id(@classroom_students_query)[0]
    @all_teachers_gitlab_id_in_class = get_all_member_id(@classroom_students_query)[1]
    # find the classroom
    classroom = Classroom.find_by(id: params[:classroom_id])
    auto_test_project = classroom.auto_test_projects.new

    classroom_gitlab = groups_service.get_group classroom[:gitlab_group_id]
    classroom_path = classroom_gitlab["full_path"]
    # debug(classroom_gitlab["web_url"])
    pair1_id = User.find_by(:username => id1)[:id]
    pair2_id = User.find_by(:username => id2)[:id]
    name = 'student_pair_project_' + pair1_id.to_s + '_' + pair2_id.to_s
    @auto_test_project = {
        'name' => name,
        'path' => name,
        # 'description'=> 'The pair project of ' + id1 + ' and ' + id2,
        'description' => '',
        'test_type'=> 'pair',
        'pair1_id'=> pair1_id,
        'pair2_id'=> pair2_id,
        'namespace_id' => classroom.pair_project_subgroup_id,
        'visibility' => 'public',
        'request_access_enabled' => true
    }
    # debug(@auto_test_project)

    # check if there is duplicated repo
    has_deplicated_name = false
    all_subgroup_repo = groups_service.get_projects(@auto_test_project['namespace_id'])
    if all_subgroup_repo
      all_subgroup_repo.each do |item|
        if item['name'] == @auto_test_project['name']
          has_deplicated_name = true
        end
      end
    end
    if has_deplicated_name
      redirect_to classroom_path(params[:classroom_id])
      return
    end

    project = projects_service.new_project(@auto_test_project)

    # add user
    gitlab_id_pair1 = User.find(@auto_test_project['pair1_id']).gitlab_id
    gitlab_id_pair2 = User.find(@auto_test_project['pair2_id']).gitlab_id
    projects_service.add_user_as_project_maintainer(project['id'], gitlab_id_pair1)
    projects_service.add_user_as_project_maintainer(project['id'], gitlab_id_pair2)

    auto_test_project.gitlab_id = project['id']
    auto_test_project.test_type = @auto_test_project['test_type']
    auto_test_project.is_public = 0

    # debug('auto p: ')
    # debug(auto_test_project)
    auto_test_project.save
    # debug(AutoTestProject.all)
    # classroom.users << owner
    # redirect_to classroom_path(params[:classroom_id])
  rescue RestClient::BadRequest => e
    @errors = ['名称或地址包含非法字符或已被占用']
    @@errors_save = @errors
    redirect_to new_pair_projects_batch_classroom_auto_test_projects_path
  end

  def debug(item)
    puts '**********'
    puts '************************'
    puts item
    puts '************************'
    puts '**********'
  end

  def create_pair_project_batch
    id_str = params[:pairForm]['text']
    # debug(id_str)
    id_slice = id_str.split(' ')
    # debug(id_slice)
    if id_slice.size % 2 != 0
      @errors = ['输入非法']
      @@errors_save = @errors
      redirect_to new_pair_projects_batch_classroom_auto_test_projects_path
      return
    end
    i = 0
    while i < id_slice.size
      create_pair_project(id_slice[i], id_slice[i + 1])
      i = i + 2
    end
    # redirect_to classroom_path(params[:classroom_id])
  end

  # create a new project
  def create
    @classroom_students_query = SelectClassroom.where(:classroom_id => params[:classroom_id])
    @all_students_gitlab_id_in_class = []
    @all_teachers_gitlab_id_in_class = []
    @classroom_students_query.each do |item|
      tmp = User.find(item.user_id)
      if tmp.role == 'student'
        @all_students_gitlab_id_in_class.append(tmp.gitlab_id)
      else
        @all_teachers_gitlab_id_in_class.append(tmp.gitlab_id)
      end
    end

    # find the classroom
    classroom = Classroom.find_by(id: params[:classroom_id])
    auto_test_project = classroom.auto_test_projects.new
    @auto_test_project = params[:auto_test_project]
    if @auto_test_project[:test_type] == 'personal'
      @auto_test_project['namespace_id'] = classroom.personal_project_subgroup_id
    else
      @auto_test_project['namespace_id'] = classroom.pair_project_subgroup_id
    end
    if @auto_test_project[:test_type] == 'pair'
      @auto_test_project['visibility'] = 'public'
    else
      @auto_test_project['visibility'] = 'private'
    end

    @auto_test_project['request_access_enabled'] = true

    # debug(@auto_test_project)

    # check if there is duplicated repo
    has_deplicated_name = false
    all_subgroup_repo = groups_service.get_projects(@auto_test_project['namespace_id'])
    if all_subgroup_repo
      all_subgroup_repo.each do |item|
        if item['name'] == @auto_test_project[:name]
          has_deplicated_name = true
        end
      end
    end

    # find duplicate repo
    if has_deplicated_name
      redirect_to classroom_path(params[:classroom_id])
      return
    end

    project = projects_service.new_project(@auto_test_project)

    if @auto_test_project[:test_type] == 'pair'
      gitlab_id_pair1 = User.find(@auto_test_project[:pair1_id]).gitlab_id
      gitlab_id_pair2 = User.find(@auto_test_project[:pair2_id]).gitlab_id
      projects_service.add_user_as_project_maintainer(project['id'], gitlab_id_pair1)
      projects_service.add_user_as_project_maintainer(project['id'], gitlab_id_pair2)
    else
      # here add all class students to this project, with permission `reporter`
      @all_students_gitlab_id_in_class.each do |stu_id|
        projects_service.add_user_as_project_reporter(project['id'], stu_id)
      end
    end

    auto_test_project.gitlab_id = project['id']
    if @auto_test_project[:test_type] == 'pair-public'
      auto_test_project.test_type = 'pair'
    else
      auto_test_project.test_type = @auto_test_project[:test_type]
    end
    if @auto_test_project[:test_type] == 'pair'
      auto_test_project.is_public = 0
    else
      auto_test_project.is_public = 1
    end
    auto_test_project.save
    # classroom.users << owner
    redirect_to classroom_path(params[:classroom_id])
  rescue RestClient::BadRequest => e
    @errors = ['名称或地址包含非法字符或已被占用']
    @@errors_save = @errors
    # render 'new'
    redirect_to new_classroom_auto_test_project_path + '?type=' + @@project_type
  end

  def new_private_personal_project
    @classroom_id = params[:classroom_id]
    @errors = []
  end

  # create a private personal project
  def create_private_personal_project
    @classroom = Classroom.find(params[:class_id])
    @classroom_students_query = SelectClassroom.where(:classroom_id => params[:class_id])
    @all_students_gitlab_id_in_class = []
    @all_teachers_gitlab_id_in_class = []
    @classroom_students_query.each do |item|
      tmp = User.find(item.user_id)
      if tmp.role == 'student'
        @all_students_gitlab_id_in_class.append(tmp.gitlab_id)
      else
        @all_teachers_gitlab_id_in_class.append(tmp.gitlab_id)
      end
    end
    # todo: ADD PAIR, use TYPE to differ them
    @gitlab_namespace_id = @classroom.personal_project_subgroup_id


    # @users = groups_service.get_members @classroom.gitlab_group_id

    if params[:type] == 'class'
      @@creating_private_personal_project = true
      @students = []
      # use @all_students_gitlab_id_in_class to get student info in gitlab
      all_users = users_service.all
      all_users[0].each do |item|
        if @all_students_gitlab_id_in_class.index(item['id'])
          @students.append(item)
        end
      end

      @@total_students_num = @students.length
      batch_create_student_private_project(@students, @gitlab_namespace_id)
      @@creating_private_personal_project = false
    else
      @student = {}
      student_record = User.find(params[:user_id])
      @student['id'] = student_record.gitlab_id
      @student['username'] = student_record.username
      create_student_private_project(@student, @gitlab_namespace_id)
    end
  end

  def get_personal_project_status
    return_list = {
      is_creating: @@creating_private_personal_project,
      # is_creating: true,
      progress: @@private_personal_project_progress
    }
    render json: return_list
  end

  def destroy
    @auto_test_project = AutoTestProject.find_by(gitlab_id: params[:id])
    @auto_test_project.destroy
    projects_service.delete_project params[:id]
    redirect_to classroom_path(params[:classroom_id])
  end

  def feedback
    respond_to do |format|
      format.json do
        feedback = params[:feedback]
        test_record = get_test_record
        test_record.feedback = feedback
        test_record.save
        render json: {status: 'success'}
      end
    end
  end

  def trigger
    respond_to do |format|
      format.json do
        test_record = get_test_record
        action = params[:trigger]
        if action == 'start'
          gitlab_username = test_record.user.username
          pipeline = create_pipeline test_record.project_id, gitlab_username
          test_record.pipeline_id = pipeline['id']
          test_record.save
        elsif action == 'cancel'
          cancel_pipeline test_record.project_id, test_record.pipeline_id
          test_record.pipeline_id = nil
          test_record.save
        end
        render json: {status: 'success'}
      end
    end
  end

  def new_auto_test_point
    @classroom_id = params[:classroom_id]
    @test_type = params[:test_type]
    @public_personal_project_id = AutoTestProject.find_by(
      :classroom_id => @classroom_id,
      :test_type => @test_type,
      :is_public => 1
    ).gitlab_id
    @errors = []
    render 'auto_test_projects/create_auto_test_point'
  end

  def create_auto_test_point
    Runner.all.each do |runner|
      res = auto_test_runners_service.create_auto_test_point(
        params[:project_id],
        params[:input],
        params[:expected_output],
        runner[:path]
      )
      puts('[Debug] create_auto_test_point in runner{runner[:uid]} >>>>>>>>>>')
      puts(res)
    end
    redirect_to(classroom_path(id: params[:classroom_id]))
  end

  def get_auto_test_repo
    auto_test_record = AutoTestProject.find_by(:gitlab_id => params['params']['project_id'])
    auto_test_classroom_id = auto_test_record.classroom_id
    auto_test_type = auto_test_record.test_type
    auto_test_students_record = AutoTestProject.where(
      :classroom_id => auto_test_classroom_id,
      :test_type => auto_test_type,
      :is_public => 0
    )

    git_repo_list = ''
    auto_test_students_record.each do |item|
      git_repo_list += projects_service.project(item.gitlab_id)['http_url_to_repo'] + ','
    end
    git_repo_list.chop!
    render plain: git_repo_list
  end

  def new_start_auto_test
    @classroom_id = params[:classroom_id]
    test_type = params[:test_type]
    @public_personal_project_id = AutoTestProject.find_by(
      :classroom_id => @classroom_id,
      :test_type => test_type,
      :is_public => 1
    ).gitlab_id
    @errors = []
    @runners = Runner.all
    render 'auto_test_projects/start_auto_test'
  end

  # start a new auto test
  def start_auto_test
    auto_test_record = AutoTestProject.find_by(:gitlab_id => params[:project_id])
    auto_test_classroom_id = auto_test_record.classroom_id
    auto_test_type = auto_test_record.test_type
    auto_test_students_record = AutoTestProject.where(
      :classroom_id => auto_test_classroom_id,
      :test_type => auto_test_type,
      :is_public => 0
    )

    git_repo_list = ''
    auto_test_students_record.each do |item|
      git_repo_list += projects_service.project(item.gitlab_id)['http_url_to_repo'] + ','
    end
    git_repo_list.chop!

    # puts('::::::::::::::::::::::::::')
    # puts(git_repo_list)

    use_text_file = false
    if params[:use_text_file] == 'true'
      use_text_file = true
    end

    use_text_output = false
    if params[:use_text_output] == 'true'
      use_text_output = true
    end

    compile_command = nil
    if params[:compile_command] != ''
      compile_command = params[:compile_command]
    end

    exec_command = nil
    if params[:exec_command] != ''
      exec_command = params[:exec_command]
    end

    runner = Runner.find_by(uid: params[:runner_uid])
    auto_test_runners_service.start_auto_test(
      auto_test_type,
      params[:project_id],
      git_repo_list,
      runner[:path],
      use_text_file,
      use_text_output,
      compile_command,
      exec_command
    )
  end

  # get result
  def get_auto_test_results
    @classroom_id = params[:classroom_id]
    test_type = params[:test_type]
    @public_personal_project_id = AutoTestProject.find_by(
      :classroom_id => @classroom_id,
      :test_type => test_type,
      :is_public => 1
    ).gitlab_id
    @refined_results = []
    Runner.all.each do |runner|
      auto_test_results = auto_test_runners_service.get_auto_test_results(@public_personal_project_id, runner[:path])
      auto_test_results.keys.each do |key|
        auto_test_results[key]['name'] = User.find(key.to_i).username
        @refined_results.append(auto_test_results[key])
      end
    end
    puts('>>>>>>>>>>>>>')
    puts(@refined_results)
    puts('>>>>>>>>>>>>>')
    @no_result = 'no'
    @table_width = '20'
    if @refined_results.empty?
      @no_result = 'yes'
    else
      @test_case_num = @refined_results[0].length - 1
      @refined_results = @refined_results.to_json
      @table_width = 1.0 / @test_case_num * 100
    end
    @table_width = @table_width.to_s + '%'

    render 'auto_test_projects/auto_test_results'
  end

  def get_auto_test_points
    @classroom_id = params[:classroom_id]
    test_type = params[:test_type]
    @public_personal_project_id = AutoTestProject.find_by(
      :classroom_id => @classroom_id,
      :test_type => test_type,
      :is_public => 1
    ).gitlab_id
    auto_test_points = auto_test_runners_service.get_auto_test_points(@public_personal_project_id)
    @points = []
    # while parsing JSON, the key is string
    auto_test_points.each do |item|
      @points.push({:index => item['id'], :input => item['input'], :expected_output => item['expected_output']})
    end

    @points = @points.to_json
    @test_type = test_type
    @classroom_id = params[:classroom_id]
    render 'auto_test_projects/auto_test_points'
  end

  def remove_auto_test_point
    Runner.all.each do |runner|
      auto_test_runners_service.remove_auto_test_point(params[:point_id], runner[:path])
    end
    redirect_to get_auto_test_points_classroom_auto_test_projects_path(params[:classroom_id],
                                                                  :test_type => params[:test_type])
  end

  private

  # 一下两个方法都与gitlab通过API交互，所以需要先从gitlab中取出相应的字段值
  def batch_create_student_private_project(students, namespace_id)
    cnt = 0
    students.each do |student|
      create_student_private_project(student, namespace_id)
      cnt += 1
      @@private_personal_project_progress = 100 * (cnt / @@total_students_num)
    end
  end

  def create_student_private_project(student, namespace_id)
    @auto_test_project = {}
    student_platform_id = User.find_by(:gitlab_id => student['id']).id

    # check whether student already has repo
    all_group_projects = groups_service.get_projects(namespace_id)
    create_new_repo = true
    all_group_projects.each do |item|
      if item['name'] == PERSONAL_HOMEWORK_PROJECT_NAME + student['username'] + '_' + student_platform_id.to_s
        create_new_repo = false
      end
    end

    if create_new_repo
      @auto_test_project['name'] = PERSONAL_HOMEWORK_PROJECT_NAME + student['username'] + '_' + student_platform_id.to_s
      @auto_test_project['visibility'] = 'private'
      @auto_test_project['request_access_enabled'] = true
      @auto_test_project['namespace_id'] = namespace_id
      auto_test_project = @classroom.auto_test_projects.new
      project_id = projects_service.new_project_for_user(student['id'], @auto_test_project)
      auto_test_project.gitlab_id = project_id
      auto_test_project.test_type = 'personal'
      auto_test_project.is_public = 0
      auto_test_project.save
    else
      puts("[Debug] student #{student_platform_id} already has a repo, continue")
      puts("????>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>**********************************")
    end
  end

  def create_pipeline(project_id, gitlab_username)
    pipeline = {
      ref: 'master',
      variables: [
        {
          # predefined CI 变量改为该项目 owner
          key: 'GITLAB_USER_LOGIN',
          value: gitlab_username
        }
      ]
    }
    admin_api_post "projects/#{project_id}/pipeline", pipeline
  end

  def cancel_pipeline(project_id, pipeline_id)
    if pipeline_id
      admin_api_post "projects/#{project_id}/pipelines/#{pipeline_id}/cancel", {}
      admin_api_delete "projects/#{project_id}/pipelines/#{pipeline_id}"
    end
  end

  def get_test_record
    auto_test_project = AutoTestProject.find(params[:id])
    auto_test_project.student_test_records.find(params[:test_record_id])
  end

  def projects_service
    ::ProjectsService.new current_user
  end

  def groups_service
    ::GroupsService.new current_user
  end

  def users_service
    ::UsersService.new current_user
  end

  def auto_test_runners_service
    ::AutoTestRunnersService.new
  end
end
