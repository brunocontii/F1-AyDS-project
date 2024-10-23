# frozen_string_literal: true

# Esta migración crea la tabla 'options', donde se guardan las diferentes opciones
# para las preguntas. Cada opción está vinculada a una pregunta específica.
class CreateOptionTable < ActiveRecord::Migration[7.1]
  def change
    create_table :options do |t|
      t.text :name_option
      t.references :question, null: false, foreign_key: true
      t.boolean :correct, default: false

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
