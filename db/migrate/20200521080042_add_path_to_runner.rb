class AddPathToRunner < ActiveRecord::Migration[5.2]
  def change
    add_column :runners, :path, :string
  end
end
