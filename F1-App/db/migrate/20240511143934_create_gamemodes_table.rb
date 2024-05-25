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
