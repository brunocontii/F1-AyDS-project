# frozen_string_literal: true

class Gamemode < ActiveRecord::Base
  has_and_belongs_to_many :user
  has_and_belongs_to_many :answer
end
