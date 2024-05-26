class CreateUsersTable < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.integer :cant_life
      t.integer :cant_coins
      t.datetime :last_life_lost_at
      
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
