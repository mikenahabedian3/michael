class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :job_id
      t.string :company_name
      t.string :location
      t.string :via
      t.string :thumbnail
      t.text :description
      t.text :job_highlights, array: true
      t.text :related_links, array: true
      t.text :extensions, array: true
      t.text :detected_extensions, array: true
      t.references :user_job_search_parameter

      t.timestamps
    end
  end
end
