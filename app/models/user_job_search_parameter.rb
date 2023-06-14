# frozen_string_literal: true

class UserJobSearchParameter < ApplicationRecord
  has_many :jobs

  COUNTRY = [
    ["India", "in"], ["China", "china"], ["US", "us"], ["UK", "uk"]
  ]
end
