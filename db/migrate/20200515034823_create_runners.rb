class CreateRunners < ActiveRecord::Migration[5.2]
  def change
    create_table :runners do |t|
      t.string :name
      t.string :address
      t.string :token
      t.string :system

      t.timestamps
    end
  end
end
