# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @jobs = Job.all
  end
end
