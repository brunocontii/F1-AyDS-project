# frozen_string_literal: true

# Esta migración crea la tabla 'questions', que almacena las preguntas del juego.
# Las preguntas pueden ser de texto o imágenes y están vinculadas a opciones y respuestas.
class CreateQuestionTable < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :name_question
      t.string :image_question
      t.string :level
      t.string :theme
      t.integer :correct
      t.integer :incorrect

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
