module JobSearch
  extend ActiveSupport::Concern

  def get_all_jobs(filtered_params)
    response = JobService.new(
      q: filtered_params[:q],
      location: filtered_params[:location],
      country: filtered_params[:country],
      page: filtered_params[:page]
    ).call
    if (response[:success])
      flash[:success] = response[:messages]
    else
      flash[:alert] = response[:messages]
    end
    { next_page: response[:next_page], jobs: response[:data] }
  end
end
