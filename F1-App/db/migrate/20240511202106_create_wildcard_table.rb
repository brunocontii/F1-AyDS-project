class CreateWildcardTable < ActiveRecord::Migration[7.1]
  def change
    create_table :wildcards do |t|
      t.string :name
      t.integer :cost
      t.references :user, foreign_key: true
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
