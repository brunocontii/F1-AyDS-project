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
