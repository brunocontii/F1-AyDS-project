class Question < ActiveRecord::Base
    validates :level, inclusion: { in: %w(easy normal difficult impossible)}
    validates :theme, inclusion: { in: %w(circuit team career pilot)}
    has_one :correct_answer, class_name: 'Option'
    has_many :incorrect_answer, class_name: 'Option'
end