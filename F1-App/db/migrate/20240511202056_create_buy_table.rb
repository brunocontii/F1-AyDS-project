class CreateBuyTable < ActiveRecord::Migration[7.1]
  def change
    create_table :buys do |t|
      t.integer :cant_coins_spent
      t.references :user, foreign_key: true
      t.references :wildcard, foreign_key: true
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
