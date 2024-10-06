class Question < ActiveRecord::Base
    has_many :answer
    has_many :options
    validates :level, inclusion: { in: %w(easy normal difficult impossible)}
    validates :theme, inclusion: { in: %w(circuit team career pilot free grandprix)}
    validates :name_question, presence: true, if: :text_question?
    validates :image_question, presence: true, if: :image_question?

    def text_question?
        name_question.present?
    end

    def image_question?
        image_question.present?
    end
end
