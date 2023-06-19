# frozen_string_literal: true

class HomeController < ApplicationController
  include JobSearch

  def index
    @jobs = Job.all.paginate(page: params[:page], per_page: 10).order(created_at: :desc)
  end

  def initialize_chatgpt
  end

  def chatgpt_response
    user_question_and_response_from_ai = ask_ai(params["message"])
    get_job_title_country_city_from_message = ask_ai("Can you please return me job title, country and city name from the following text message?\n #{params["message"]}")

    build_job_data = { jobs: "" }
    job_search_params = get_job_title_country_city_from_message.dig("choices", 0, "message", "content").nil? ? [] : get_job_title_country_city_from_message.dig("choices", 0, "message", "content").split("\n")
    if job_search_params.size >= 3
      build_job_data = build_job_data(job_search_params)
    end

    render json: { 
      data: [
        ai_response: user_question_and_response_from_ai.dig("choices", 0, "message", "content"),
        jobs: build_job_data[:jobs]
      ]
    }
  end

  def build_job_data(job_search_params)
    search_text = job_search_params.first(3)
    job_title = search_text[0].split(":")
    country = search_text[1].split(":")
    location = search_text[2].split(":")
    job_data = ""
    if (job_title.include? "Job Title") || (country.include? "country_code") || (location.include? "City")
      country = country[1].blank? ? "" : country[1].strip
      country = Country.where("lower(sortname) = ? OR lower(name) = ?", country.downcase, country.downcase).first&.sortname
      country = country.nil? ? "" : country
      job_title = job_title[1].blank? ? "" : job_title[1].strip
      location = location[1].blank? ? "" : location[1].strip
      if (!job_title.blank? && !country.blank? && !location.blank?)
        job_data = filtered_chat_to_get_job_details(
          job_title, country, location   
        )
      end
    end
    { jobs: job_data }
  end

  def filtered_chat_to_get_job_details(job_title, country, location)
    data = get_all_jobs({
      q: job_title,
      country: country,
      location: location,
      page: 0
    }.delete_if { |key, value| value.to_s.strip == "" })
    data[:jobs]
  end

  def ask_ai(question)
    client = OpenAI::Client.new

    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo", # Required.
        messages: [{ role: "user", content: question }],
        temperature: 0.7,
      }
    )
    response
  end
end
