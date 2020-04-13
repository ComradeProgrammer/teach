class AddTypeToAutoTestProject < ActiveRecord::Migration[5.2]
  def change
    add_column :auto_test_projects, :type, :string
  end
end
