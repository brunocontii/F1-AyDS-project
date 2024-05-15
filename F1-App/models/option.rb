class Option < ActiveRecord::Base
    belongs_to :answer
    belongs_to :question, class_name: 'Option'
end