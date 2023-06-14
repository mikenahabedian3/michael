class CreateUserJobSearchParameters < ActiveRecord::Migration[7.0]
  def change
    create_table :user_job_search_parameters do |t|
      t.string :engine
      t.string :query_q
      t.string :language_hl
      t.string :country_gl
      t.string :location
      t.string :google_domain
      t.integer :last_page_no

      t.timestamps
    end
  end
end
