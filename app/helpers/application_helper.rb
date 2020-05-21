module ApplicationHelper
  include ::GitlabApi

  def get_proj_class_name(proj_gitlab_id)
    # record = AutoTestProject.find_by(gitlab_id: proj_gitlab_id)
    record = TeamProject.find_by(gitlab_id: proj_gitlab_id)
    if record == nil # todo: this is a team project, but TeamProject is empty
      # then this must be auto test
      record = AutoTestProject.find_by(gitlab_id: proj_gitlab_id)
    end
    class_id = record["classroom_id"]
    class_record = Classroom.find(class_id)
    classroom = groups_service.get_group class_record[:gitlab_group_id]
    classroom["name"]
  end

  def current_student_classroom_id
    user_gitlab_id = current_user.id
    user = User.find_by(:gitlab_id => user_gitlab_id)
    if user.role == 'student'
      SelectClassroom.find_by(:user_id => user.id).classroom_id
    else
      nil
    end
  end

  def projects_data
    data = {}
    data['gitlabHost'] = gitlab_host
    data['classroomid'] = []
    data['classroomname'] = []
    if current_user.id
      user_gitlab_id = current_user.id
      user = User.find_by(:gitlab_id => user_gitlab_id)
      SelectClassroom.where(:user_id => user.id).each do |item|
        data['classroomid'].append(item.classroom_id)
        classroom_gitlab_id = Classroom.find(item.classroom_id).gitlab_group_id
        classroom_name = ''
        if groups_service
          classroom_name = groups_service.get_group(classroom_gitlab_id)["name"]
        end
        data['classroomname'].append("#{classroom_name} / ID: #{item.classroom_id}")
      end
      data['role'] = user.role
    end
    return data if teacher?
    project_service = ProjectsService.new current_user
    # 最小为开发者权限
    projects = project_service.all(simple: false, membership: true, min_access_level: 30)
    # puts('%%%%%%%%%%%%%%%%%%%%%')
    # puts(projects)
    # puts('%%%%%%%%%%%%%%%%%%%%%')
    infos = []
    projects.each do |project|
      # if AutoTestProject.find_by(gitlab_id: project['id'])
      if TeamProject.find_by(gitlab_id: project['id']) || AutoTestProject.find_by(gitlab_id: project['id'])
        info = {
          id: project['id'],
          name: project['name'],
          name_with_namespace: project['name_with_namespace'],
          web_url: project['web_url'],
          class_name: get_proj_class_name(project['id'])
        }
        info[:milestones] = project_service.all_milestones project['id']
        infos << info
      end
    end
    #puts('&&&&&&&')
    #puts(infos)
    data['projects'] = infos.to_json
    data['issues-endpoint'] = issues_url(format: :json)
    #if current_user.id
    #  user_gitlab_id = current_user.id
    #  user = User.find_by(:gitlab_id => user_gitlab_id)
    #  SelectClassroom.where(:user_id => user.id).each do |item|
    #    data['classroomid'].append(item.classroom_id)
    #  end
    #  data['role'] = user.role
    #end
    data
  end

  def get_broadcast_num
    if current_user.id
      user_id = User.find_by(gitlab_id: current_user.id).id
      Broadcast.where(:to_id => user_id).length
    end
  end

  def ie_svg_meta_tag
    tag('meta', 'http-equiv': 'X-UA-Compatible', content: 'IE=11').html_safe
  end

  def groups_service
    if current_user.id
      ::GroupsService.new current_user
    else
      nil
    end
  end
end
