class Question < ActiveRecord::Base
    has_many :answer
    has_many :options
    validates :level, inclusion: { in: %w(easy normal difficult impossible)}
    validates :theme, inclusion: { in: %w(circuit team career pilot free)}
end