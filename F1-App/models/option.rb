class Option < ActiveRecord::Base
    has_many :answer
    belongs_to :question
end