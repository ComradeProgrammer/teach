class DeleteTypeInAutoTestProject < ActiveRecord::Migration[5.2]
  def change
    remove_column :auto_test_projects, :test_type
  end
end
