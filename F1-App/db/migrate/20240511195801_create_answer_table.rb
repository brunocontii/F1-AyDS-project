class CreateAnswerTable < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|
      t.text :text
    end
  end
end
