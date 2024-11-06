# frozen_string_literal: true

# Esta migración crea la tabla 'profiles', que almacena los perfiles de los usuarios.
# La tabla puede contener información adicional del usuario, como avatar, estadísticas
# y preferencias, vinculadas mediante una relación con la tabla 'users'.
class CreateProfilesTable < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.string :name, :lastName, :email
      t.text :description
      t.integer :age
      t.string :profile_picture
      t.references :user, null: false, foreign_key: true

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
