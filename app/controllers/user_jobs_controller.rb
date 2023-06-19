# frozen_string_literal: true

class UserJobsController < ApplicationController
  before_action :authenticate_user!

  def index
    @jobs = current_user.jobs.paginate(page: params[:page], per_page: 10).order(created_at: :desc)
  end

  def save_job
    current_user.user_jobs.create(job_id: params[:job_id])
    flash[:notice] = "Successfully saved this job!"
    redirect_back(fallback_location: root_path)
  end

  private

  def filter_params
    params.permit!
  end
end
