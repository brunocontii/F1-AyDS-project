class CreateReplyTable < ActiveRecord::Migration[7.1]
  def change
    create_table :replies do |t|
      t.integer :cant_coins_won
    end
  end
end
