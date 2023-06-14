# frozen_string_literal: true

require "google_search_results"

module GoogleJobs
  class Finder < ApplicationService
    def initialize(filters = {})
      @params = {
        engine: "google_jobs",
        q: filters[:q],
        hl: filters[:hl],
        gl: filters[:gl],
        location: filters[:location],
        api_key: "d5e82d54ec84cf909fee6a496096458befb407d94b470715d1b28b8553e6cbe8",
        google_domain: filters[:google_domain],
        start: filters[:last_page_no]
      }
    end

    def call
      return if @params[:q].nil? || @params.empty?

      search = GoogleSearch.new(@params)
      results = search.get_hash
      data = {
        response: results[:search_metadata],
        search_params: results[:search_parameters],
        search_information: results[:search_information],
        error: results[:error].present?,
        jobs_results: results[:jobs_results]
      }
      data
    end
  end
end
