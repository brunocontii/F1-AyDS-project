class CreateProgressiveTable < ActiveRecord::Migration[7.1]
  def change
    create_table :progressives do |t|
      t.string :name_theme
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
