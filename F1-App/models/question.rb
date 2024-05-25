class Question < ActiveRecord::Base
    has_many :answer
    has_many :options
    validates :level, inclusion: { in: %w(easy normal difficult impossible)}
    validates :theme, inclusion: { in: %w(circuit team career pilot)}
    #has_one :correct_option, class_name: 'Option', foreign_key: 'correct_option_id'
    #has_many :incorrect_options, class_name: 'Option', foreign_key: 'incorrect_option_id'
end