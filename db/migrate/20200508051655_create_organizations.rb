class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :code
      t.string :token
      t.text :description

      t.timestamps
    end
  end
end
