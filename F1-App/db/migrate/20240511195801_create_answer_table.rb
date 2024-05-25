class CreateAnswerTable < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|
      t.references :question, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
