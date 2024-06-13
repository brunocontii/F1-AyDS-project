class CreateProfilesTable < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :lastName
      t.text :description
      t.integer :age
      t.string :profile_picture
      t.references :user, null: false, foreign_key: true

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
