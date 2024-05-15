class CreateBuyTable < ActiveRecord::Migration[7.1]
  def change
    create_table :buys do |t|
      t.integer :cant_coins_spent
    end
  end
end
