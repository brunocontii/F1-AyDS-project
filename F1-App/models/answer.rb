# frozen_string_literal: true

# Esta clase registra las respuestas de los usuarios.
# Almacena la opción seleccionada por el usuario y si fue correcta o incorrecta.
class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :gamemode
  belongs_to :question
  belongs_to :option
end
