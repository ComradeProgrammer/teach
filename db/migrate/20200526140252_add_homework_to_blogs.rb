class AddHomeworkToBlogs < ActiveRecord::Migration[5.2]
  def change
    add_column :blogs, :homework, :integer
  end
end
