module ApplicationHelper
  include ::GitlabApi

  def get_proj_class_name(proj_gitlab_id)
    record = AutoTestProject.find_by(gitlab_id: proj_gitlab_id)
    if record == nil # todo: this is a team project, but TeamProject is empty
    end
    class_id = record["classroom_id"]
    class_record = Classroom.find(class_id)
    classroom = groups_service.get_group class_record[:gitlab_group_id]
    classroom["name"]
  end

  def projects_data
    data = {}
    data['gitlabHost'] = gitlab_host
    return data if teacher?
    project_service = ProjectsService.new current_user
    # 最小为开发者权限
    projects = project_service.all(simple: false, membership: true, min_access_level: 30)
    infos = []
    projects.each do |project|
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
    data['projects'] = infos.to_json
    data['issues-endpoint'] = issues_url(format: :json)
    data
  end

  def ie_svg_meta_tag
    tag('meta', 'http-equiv': 'X-UA-Compatible', content: 'IE=11').html_safe
  end
end
