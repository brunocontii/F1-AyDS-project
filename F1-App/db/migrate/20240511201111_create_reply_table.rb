class CreateReplyTable < ActiveRecord::Migration[7.1]
  def change
    create_table :replies do |t|
      t.integer :cant_coins_won
      t.references :user, foreign_key: true
      t.references :answer, foreign_key: true
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
