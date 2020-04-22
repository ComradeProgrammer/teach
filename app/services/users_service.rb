class UsersService < BaseService
  def all(params = {})
    get_with_headers 'users', params
  end

  def get_user_info(user_id)
    get("users/#{user_id}")
  end
end