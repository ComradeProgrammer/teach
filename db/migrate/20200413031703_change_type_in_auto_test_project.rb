class ChangeTypeInAutoTestProject < ActiveRecord::Migration[5.2]
  def change
    rename_column :auto_test_projects, :type, :test_type
  end
end
