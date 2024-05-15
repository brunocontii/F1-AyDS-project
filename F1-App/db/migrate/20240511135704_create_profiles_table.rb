class CreateProfilesTable < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :lastName
      t.text :description
      t.integer :age
    end
  end
end
