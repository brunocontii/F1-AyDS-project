class CreateOptionTable < ActiveRecord::Migration[7.1]
  def change
    create_table :options do |t|
      t.text :text
      t.integer :id_o
    end
  end
end
