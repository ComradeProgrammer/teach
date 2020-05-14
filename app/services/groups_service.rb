class GroupsService < BaseService
  def new_group(group)
    post 'groups', group
  end

  def update_group(group_id, update)
    put "groups/#{group_id}", update
  end

  def get_group(group_id)
    get "groups/#{group_id}"
  end

  def delete_group(group_id)
    delete "groups/#{group_id}"
  end

  def get_projects(group_id)
    get "groups/#{group_id}/projects"
  end

  def add_member(group_id, member)
    post "groups/#{group_id}/members", member
  end

  def get_members(group_id)
    get "groups/#{group_id}/members/all"
  end

  def delete_member(group_id, user_id)
    delete "groups/#{group_id}/members/#{user_id}"
  end

  def get_group_statistics(group_id)
    all_sub_groups_info = get "groups/#{group_id}/subgroups"
    res = {
      :commit_count => 0,
      :repository_size => 0,
      :storage_size => 0,
    }
    all_sub_groups_info.each do |subgroup|
      sub_id = subgroup['id']
      all_projects_info = get "groups/#{sub_id}/projects"
      all_projects_info.each do |project|
        project_info = get "projects/#{project['id']}?statistics=true"
        res[:commit_count] += project_info['statistics']['commit_count']
        # KB
        res[:repository_size] += project_info['statistics']['repository_size'] / 1024.0
        res[:storage_size] += project_info['statistics']['storage_size'] / 1024.0
      end
    end
    # puts res
    res[:repository_size] = res[:repository_size].round
    res[:storage_size] = res[:storage_size].round
    res
  end
end