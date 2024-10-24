class CreateQuestionTable < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :name_question
      t.string :image_question
      t.string :level
      t.string :theme
      t.integer :correct
      t.integer :incorrect

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
