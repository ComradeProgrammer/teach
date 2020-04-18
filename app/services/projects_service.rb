class ProjectsService < BaseService
  def project(project_id)
    get("projects/#{project_id}")
  end

  def new_project(project)
    post "projects", project
  end

  def add_user_as_project_reporter(project_id, user_id)
    # 10 => Guest access
    # 20 => Reporter access
    # 30 => Developer access
    # 40 => Maintainer access
    # 50 => Owner access # Only valid for groups
    # puts('>>>>>>>><<<<<>>')
    # puts({user_id: user_id, access_level: 20})
    post("projects/#{project_id}/members", {user_id: user_id, access_level: 20})
  end

  def new_project_for_user(user_id, project)
    # print(project)
    res = post "projects/", project
    project_id = res['id']
    post("projects/#{project_id}/members", {user_id: user_id, access_level: 40})
    return project_id
  end

  def delete_project(project)
    delete "projects/#{project}"
  end

  def forks(project_id, params = {})
    get "projects/#{project_id}/forks", params
  end

  def all(params = {})
    get('projects', params)
  end

  def all_members(project_id)
    members = []
    list = get("projects/#{project_id}/members")
    list.each do |member|
      members << {
        id: member['id'],
        name: member['name'],
        avatar: member['avatar_url'],
        username: member['username'],
        access: member_access(member['access_level'])
      }
    end
    members
  end

  def all_milestones(project_id)
    milestones = []
    list = get "projects/#{project_id}/milestones"
    list.each do |milestone|
      # next if milestone['state'] == 'closed'
      milestones << {
        id: milestone['id'],
        iid: milestone['iid'],
        project_id: milestone['project_id'],
        title: milestone['title'],
        start_date: milestone['start_date'],
        due_date: milestone['due_date']
      }
    end
    milestones
  end

  def member_access(level)
    # guest 权限为10
    if level > 10
      'edit'
    else
      'new'
    end
  end

  def all_labels(project_id)
    labels = []
    # projects = all(simple: true).map { |i| i['id'] }
    list = get("projects/#{project_id}/labels")
    list.each do |label|
      labels << {
        id: label['id'],
        name: label['name']
      }
    end
    labels
  end
end