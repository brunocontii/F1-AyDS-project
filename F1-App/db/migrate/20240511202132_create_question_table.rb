class CreateQuestionTable < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :name_question
      t.integer :id_q
      t.string :level
      t.string :theme
    end
  end
end
