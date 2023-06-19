# frozen_string_literal: true

class SearchJobsController < ApplicationController
  include JobSearch

  def index
    data = get_all_jobs(filtered_params)
    @next_page = data[:next_page]
    @jobs = data[:jobs]
  end

  def show
    @job = Job.find_by_id(params[:id])
  end

  private

  def filtered_params
    params.permit!
  end
end
