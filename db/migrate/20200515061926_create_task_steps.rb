class CreateTaskSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :task_steps do |t|
      t.date :step_date
      t.string :title
      t.text :description
      t.integer :task_period_id

      t.timestamps
    end
  end
end
