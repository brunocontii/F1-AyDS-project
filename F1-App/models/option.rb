# frozen_string_literal: true

# Esta clase define las opciones para una pregunta específica.
# Almacena las diferentes alternativas que se presentan al usuario
# como posibles respuestas.
class Option < ActiveRecord::Base
  has_many :answer
  belongs_to :question
end
