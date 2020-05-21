class AddOsToRunner < ActiveRecord::Migration[5.2]
  def change
    add_column :runners, :os, :string
  end
end
