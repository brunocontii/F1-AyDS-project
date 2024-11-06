# frozen_string_literal: true

# Esta migración crea la tabla 'answers', que registra las respuestas de los usuarios
# a las preguntas. Contiene información sobre la opción elegida y si fue correcta o incorrecta.
class CreateAnswerTable < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|
      t.references :question, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
