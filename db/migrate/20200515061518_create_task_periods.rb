class CreateTaskPeriods < ActiveRecord::Migration[5.2]
  def change
    create_table :task_periods do |t|
      t.date :from_date
      t.date :to_date
      t.string :title
      t.text :description
      t.integer :classroom_id

      t.timestamps
    end
  end
end
