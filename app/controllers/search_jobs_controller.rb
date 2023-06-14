# frozen_string_literal: true

class SearchJobsController < ApplicationController
  def index
    @response = JobService.new(
                            q: filter_params[:q],
                            location: filter_params[:location],
                            country: filter_params[:country]
                          ).call
    if (@response[:success])
      flash[:success] = @response[:messages]
    else
      flash[:alert] = @response[:messages]
    end
    @jobs = @response[:data]
  end

  private

  def filter_params
    params.permit!
  end
end
