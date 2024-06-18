class CreateQuestionTable < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :name_question
      t.string :level
      t.string :theme

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
