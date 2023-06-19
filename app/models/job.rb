# frozen_string_literal: true

class Job < ApplicationRecord
  belongs_to :user_job_search_parameter
  has_many :user_jobs
  has_many :users, through: :user_jobs
end
