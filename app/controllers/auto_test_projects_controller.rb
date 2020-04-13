class AutoTestProjectsController < ApplicationController
  def show
  end

  def new
    @errors = []
    @classroom_id = params[:classroom_id]
    classroom = Classroom.find_by(id: @classroom_id)
    @classroom_name = groups_service.get_group(classroom.gitlab_group_id)['path']
    @type = params[:type]
    if params[:type] == 'personal'
      @title = '个人'
      @projects_name = 'personal-projects'
      @auto_test_project = AutoTestProject.new('personal')
    else
      @title = '结对'
      @projects_name = 'pair-projects'
      @auto_test_project = AutoTestProject.new('pair')
    end
  end

  def create
    classroom = Classroom.find_by(id: params[:classroom_id])
    auto_test_project = classroom.auto_test_projects.new
    @auto_test_project = params[:auto_test_project]
    if @auto_test_project[:test_type] == 'personal'
      @auto_test_project['namespace_id'] = classroom.personal_project_subgroup_id
    else
      @auto_test_project['namespace_id'] = classroom.pair_project_subgroup_id
    end
    @auto_test_project['visibility'] = 'public'
    @auto_test_project['request_access_enabled'] = true
    project = projects_service.new_project(@auto_test_project)
    auto_test_project.gitlab_id = project['id']
    auto_test_project.test_type = @auto_test_project[:test_type]
    auto_test_project.save
    # classroom.users << owner
    redirect_to classroom_path(params[:classroom_id])
  rescue RestClient::BadRequest => e
    @errors = ['名称或地址包含非法字符或已被占用']
    render 'new'
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

  private

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
end
