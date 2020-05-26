class AddScore2ToBlogs < ActiveRecord::Migration[5.2]
  def change
    add_column :blogs, :score2, :integer
  end
end
