class AddUidToRunner < ActiveRecord::Migration[5.2]
  def change
    add_column :runners, :uid, :string
  end
end
