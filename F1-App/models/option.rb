class Option < ActiveRecord::Base
    belongs_to :answer
    belongs_to :correct_question, class_name: "Question"
    belongs_to :incorrect_question, class_name: "Question"
end