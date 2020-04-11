class CreateBroadcasts < ActiveRecord::Migration[5.2]
  def change
    create_table :broadcasts do |t|
      t.string :content
      t.integer :from_id
      t.integer :to_id

      t.timestamps
    end
  end
end
