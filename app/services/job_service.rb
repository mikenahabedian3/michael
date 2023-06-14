# frozen_string_literal: true

class JobService < ApplicationService
  def initialize(q:, location:, country: "in", language: "en", page_no: 0)
    @params = {
      q: q,
      hl: language,
      gl: country,
      location: location,
      google_domain: "google.com",
      last_page_no: page_no
    }
  end

  def call
    search_params = UserJobSearchParameter.where(
      engine: "google_jobs",
      query_q: @params[:q],
      language_hl: @params[:hl],
      country_gl: @params[:gl],
      location: @params[:location],
      google_domain: @params[:google_domain],
      last_page_no: @params[:last_page_no]
    ).where("created_at > ?", 1.week.ago.to_date)

    if search_params.any?
      { success: true, data: Job.where(user_job_search_parameter_id: search_params.last.id), messages: "Filtered job results" }
    else
      fetch_data_from_api_store_return
    end
  end

  def fetch_data_from_api_store_return
    @response = GoogleJobs::Finder.new(@params).call
    if @response[:error]
      { success: false, data: [], messages: @response[:search_information][:jobs_results_state] }
    else
      store_jobs_in_db_and_store_the_parameters(@response[:jobs_results])
    end
  end

  def store_jobs_in_db_and_store_the_parameters(jobs)
    user_job_search_parameter = UserJobSearchParameter.new(
      {
        engine: "google_jobs",
        query_q: @params[:q],
        language_hl: @params[:hl],
        country_gl: @params[:gl],
        location: @params[:location],
        google_domain: @params[:google_domain],
        last_page_no: @params[:last_page_no]
      }
    )
    user_job_search_parameter.save
    jobs.each do |job|
      user_job_search_parameter.jobs.create(
        title: job[:title],
        job_id: job[:job_id],
        company_name: job[:company_name],
        location: job[:location],
        via: job[:via],
        thumbnail: job[:thumbnail],
        description: job[:description],
        job_highlights: job[:job_highlights],
        related_links: job[:related_links],
        extensions: job[:extensions],
        detected_extensions: [job[:detected_extensions]]
      )
    end
    { success: true, data: user_job_search_parameter.jobs, messages: "Filtered job results" }
  end
end