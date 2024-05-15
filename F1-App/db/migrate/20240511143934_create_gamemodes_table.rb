class CreateGamemodesTable < ActiveRecord::Migration[7.1]
  def change
    create_table :gamemodes do |t|
      t.string :name
      t.integer :progress
    end
  end
end
