class AddIsPublicToAutoTestProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :auto_test_projects, :is_public, :integer
  end
end
