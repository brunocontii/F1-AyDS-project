class Option < ActiveRecord::Base
    has_many :answer
    belongs_to :question
    #belongs_to :correct_question, class_name: "Question"
    #belongs_to :incorrect_question, class_name: "Question"
end