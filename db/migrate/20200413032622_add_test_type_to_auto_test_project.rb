class AddTestTypeToAutoTestProject < ActiveRecord::Migration[5.2]
  def change
    add_column :auto_test_projects, :test_type, :string
  end
end
