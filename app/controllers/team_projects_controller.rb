class TeamProjectsController < ApplicationController
  @@dup_proj = false
  @@errors_save = []

  def new
    @errors = []
    # find if duplicate
    if @@errors_save.size > 0
      @errors = @@errors_save
      @@errors_save = []
    end
    if @@dup_proj
      @errors = ['名称重复']
      @@dup_proj = false
    end
    @classroom_id = params[:classroom_id]
    # puts('team >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
    # puts(params)
    # puts(@classroom_id)
    # puts('team >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
    @team_project = {
      name: '',
      path: '',
      description: '',
      initialize_with_readme: false
    }
  end

  def new_team_projects_batch
    @errors = []
    # find if duplicate
    if @@errors_save.size > 0
      @errors = @@errors_save
      @@errors_save = []
    end
    if @@dup_proj
      @errors = ['名称重复']
      @@dup_proj = false
    end
    @classroom_id = params[:classroom_id]
    @team_project = {
        name: '',
        path: '',
        description: '',
        initialize_with_readme: false
    }
  end

  def debug(item)
    puts '**********'
    puts '************************'
    puts item
    puts '************************'
    puts '**********'
  end

  def create_team_project(team_name, id_array)
    save_team_projects = TeamProject.new
    # @team_project = params[:team_project]
    @team_project = {
        'name' => team_name,
        'path' => team_name,
        'description' => '',
        'initialize_with_readme' => true,
        'members' => []
    }
    # look up for duplicate projects
    @@dup_proj = false
    TeamProject.all.each do |a_project|
      if a_project[:name] == @team_project['name']
        @@dup_proj = true
        redirect_to new_classroom_team_project_path
        return
      end
    end
    @team_project[:initialize_with_readme] = !!@team_project[:initialize_with_readme]
    classroom = Classroom.find(params[:classroom_id])
    team_project = {
        name: @team_project['name'],
        path: @team_project['path'],
        description: @team_project['description'],
        initialize_with_readme: @team_project[:initialize_with_readme],
        namespace_id: classroom.team_project_subgroup_id
    }
    # 以 owner 身份创建项目
    owner = classroom.users.where(role: 'admin').first
    @team_project = create_project_as_owner team_project, owner.gitlab_id
    # 当前用户添加为 Maintainer
    # now we assume that only teacher could create project
    # therefore, we should add all teachers in the classroom and the group member
    # to this repo as Maintainer
    member_gitlab_id = []
    id_array.each do |username|
      id = User.find_by(:username => username)[:id]
      member_gitlab_id.append(User.find(id).gitlab_id)
    end

    save_team_projects.gitlab_id = @team_project['id']
    save_team_projects.classroom_id = params[:classroom_id]
    save_team_projects.save

    member_gitlab_id.each do |gitlab_id|
      if gitlab_id != owner.gitlab_id
        add_project_master_as_owner @team_project['id'], gitlab_id, owner.gitlab_id
        # projects_service.add_user_as_project_maintainer(@team_project['id'], gitlab_id)
      end
    end
    return
  rescue RestClient::BadRequest => e
    @errors = ['BadRequest, 可能名称或地址包含非法字符']
    @@errors_save = @errors
    redirect_to new_classroom_team_project_path
  end

  def create_team_projects_batch
    id_str = params[:teamForm]['text']
    debug(id_str.split("\n"))
    lines = id_str.split("\n")
    lines.each do |line|
      team_name = line.split(":")[0]
      id_array = line.split(":")[1].split(" ")
      # debug(team_name)
      # debug(id_array)
      create_team_project(team_name, id_array)
    end
    redirect_to classroom_path(params[:classroom_id])
  end

  def create
    # puts('team create >>>>>>>>>>>>>>>>>>>>>>>>>>>')
    # puts(params)
    # puts('team create >>>>>>>>>>>>>>>>>>>>>>>>>>>')
    # redirect_to('/classrooms')
    # return
    save_team_projects = TeamProject.new
    @team_project = params[:team_project]

    # look up for duplicate projects
    @@dup_proj = false
    TeamProject.all.each do |a_project|
      if a_project[:name] == @team_project['name']
        @@dup_proj = true
        redirect_to new_classroom_team_project_path
        return
      end
    end
    @team_project[:initialize_with_readme] = !!@team_project[:initialize_with_readme]
    classroom = Classroom.find(params[:classroom_id])
    team_project = {
      name: @team_project['name'],
      path: @team_project['path'],
      description: @team_project['description'],
      initialize_with_readme: @team_project[:initialize_with_readme],
      namespace_id: classroom.team_project_subgroup_id
    }
    # 以 owner 身份创建项目
    owner = classroom.users.where(role: 'admin').first
    @team_project = create_project_as_owner team_project, owner.gitlab_id
    # 当前用户添加为 Maintainer
    # now we assume that only teacher could create project
    # therefore, we should add all teachers in the classroom and the group member
    # to this repo as Maintainer
    member_gitlab_id = []
    @team_project_ori = params[:team_project]
    @team_project_ori[:members].each do |member|
      member_gitlab_id.append(User.find(member).gitlab_id)
    end

    save_team_projects.gitlab_id = @team_project['id']
    save_team_projects.classroom_id = params[:classroom_id]
    #puts('>>>>>>>xxxxxxxxxx')
    #puts(@team_project)
    #puts(save_team_projects.gitlab_id)
    #puts(save_team_projects.classroom_id)
    save_team_projects.save
    #puts('>>>>>>>')

    member_gitlab_id.each do |gitlab_id|
      if gitlab_id != owner.gitlab_id
        add_project_master_as_owner @team_project['id'], gitlab_id, owner.gitlab_id
        # projects_service.add_user_as_project_maintainer(@team_project['id'], gitlab_id)
      end
    end
    # redirect_to @team_project['web_url']
    return
  rescue RestClient::BadRequest => e
    @errors = ['BadRequest, 可能名称或地址包含非法字符']
    @@errors_save = @errors
    redirect_to new_classroom_team_project_path
  end

  def show
    team_project = TeamProject.find(params[:id])
    @team = get_project team_project.gitlab_id
    @members = get_project_members team_project.gitlab_id
    commits = team_project.contribution_commits
    issues = team_project.contribution_issues
    @total = Issue.where(project_id: team_project.gitlab_id).count
    @total_weight = Issue.where(project_id: team_project.gitlab_id).sum { |i| i.weight.to_i }
    @done = issues.count
    @done_weight = issues.select(:weight).joins(:issue).sum { |i| i.weight.to_i }
    @percent = @total.zero? ? 100 : @done * 100 / @total
    @percent_weight = @total_weight.zero? ? 100 : @done_weight * 100 / @total_weight

    # set up member properties
    @members.each do |member|
      member['role'] = team_role member.delete('access_level')
      user = User.find_by gitlab_id: member['id']
      member['commits_count'] = commits.where(user_id: user.id).count
      member['issues_count'] = issues.where(user_id: user.id).count
      member['issues_weight'] = issues.select(:weight)
                                      .where(user_id: user.id)
                                      .joins(:issue)
                                      .sum { |i| i.weight.to_i }
    end
  end

  private

  def projects_service
    ::ProjectsService.new current_user
  end

  def create_project_as_owner(project, owner_id)
    admin_api_post "projects?sudo=#{owner_id}", project
  end

  def add_project_master_as_owner(project_id, user_id, owner_id)
    maintainer = 40
    user = {
      user_id: user_id,
      access_level: maintainer
    }
    admin_api_post "projects/#{project_id}/members?sudo=#{owner_id}", user
  end

  def get_project(project_id)
    admin_api_get "projects/#{project_id}"
  end

  def get_project_members(project_id)
    admin_api_get "projects/#{project_id}/members"
  end

  def team_role(access_level)
    # access_level: 10 | 20 | 30 | 40 | 50
    access = %w[Guest Reporter Developer Maintainer Owner]
    access[access_level / 10 - 1]
  end
end
