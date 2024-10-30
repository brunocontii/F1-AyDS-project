# frozen_string_literal: true

# Esta migración crea la tabla 'users' en la base de datos.
# Almacena información relevante sobre los usuarios, como su nombre, correo electrónico,
# contraseñas, y otros datos relacionados con su cuenta.
class CreateUsersTable < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username, :password_digest
      t.integer :cant_life
      t.integer :cant_coins
      t.integer :total_points
      t.datetime :last_life_lost_at

      t.datetime :created_at
      t.datetime :updated_at
      t.boolean :admin
    end
  end
end
