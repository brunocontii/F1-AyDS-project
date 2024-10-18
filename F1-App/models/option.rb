# frozen_string_literal: true

class Option < ActiveRecord::Base
  has_many :answer
  belongs_to :question
end
