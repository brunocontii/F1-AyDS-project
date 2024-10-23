# frozen_string_literal: true

# Esta clase representa una pregunta del juego.
# Almacena el contenido de la pregunta, ya sea en texto o imagen,
# y está vinculada a las opciones y respuestas.
class Question < ActiveRecord::Base
  has_many :answers
  has_many :options

  validates :level, inclusion: { in: %w[easy normal difficult impossible] }
  validates :theme, inclusion: { in: %w[circuit team career pilot free grandprix] }
  validates :name_question, presence: true, if: :text_question?
  validates :image_question, presence: true, if: :image_question?

  before_create :initialize_correct_incorrect

  def text_question?
    name_question.present?
  end

  def image_question?
    image_question.present?
  end

  private

  # Inicializa correct e incorrect en 0 si no están presentes
  def initialize_correct_incorrect
    self.correct ||= 0
    self.incorrect ||= 0
  end
end
