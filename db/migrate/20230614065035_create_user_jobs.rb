class CreateUserJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :user_jobs do |t|
      t.references :user
      t.references :job

      t.timestamps
    end
  end
end
