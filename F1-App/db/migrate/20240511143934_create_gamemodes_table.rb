# frozen_string_literal: true

# Esta migración crea la tabla 'gamemodes', donde se registran los modos de juego disponibles.
# La tabla almacena configuraciones para diferentes modos que afectan la jugabilidad.
class CreateGamemodesTable < ActiveRecord::Migration[7.1]
  def change
    create_table :gamemodes do |t|
      t.string :name
      t.integer :progress

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
