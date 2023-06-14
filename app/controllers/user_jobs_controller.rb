# frozen_string_literal: true

class UserJobsController < ApplicationController

  def index
    @jobs = current_user.user_jobs
  end

  def save_job
    current_user.user_jobs.create(job_id: params[:job_id])
    redirect_to search_jobs_path(filter_params)
  end

  private

  def filter_params
    params.permit!
  end
end
