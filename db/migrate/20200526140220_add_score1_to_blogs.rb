class AddScore1ToBlogs < ActiveRecord::Migration[5.2]
  def change
    add_column :blogs, :score1, :integer
  end
end
