class ChangeDateTypeInTaskPeriodAndStep < ActiveRecord::Migration[5.2]
  def change
    change_column :task_periods, :from_date, :datetime
    change_column :task_periods, :to_date, :datetime
    change_column :task_steps, :step_date, :datetime
  end
end
