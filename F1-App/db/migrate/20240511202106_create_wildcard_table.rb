class CreateWildcardTable < ActiveRecord::Migration[7.1]
  def change
    create_table :wildcards do |t|
      t.string :name
      t.integer :cost
    end
  end
end
