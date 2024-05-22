class CreateOptionTable < ActiveRecord::Migration[7.1]
  def change
    create_table :options do |t|
      t.text :text
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
