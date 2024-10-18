# frozen_string_literal: true

class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :gamemode
  belongs_to :question
  belongs_to :option
end
