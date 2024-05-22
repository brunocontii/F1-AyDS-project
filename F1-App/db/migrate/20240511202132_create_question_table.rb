class CreateQuestionTable < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :name_question
      t.string :level
      t.string :theme
      t.integer :correct_option_id
      t.integer :incorrect_option_id

      t.timestamps
    end
  end
end
