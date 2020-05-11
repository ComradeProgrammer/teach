class MembersService < BaseService
  def new_member(member)
    post 'users', member
  end
end