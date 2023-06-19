# frozen_string_literal: true

class UserJobSearchParameter < ApplicationRecord
  has_many :jobs, dependent: :destroy

  COUNTRY = [
    ["India", "in"], ["China", "china"], ["US", "us"], ["UK", "uk"]
  ]
end
