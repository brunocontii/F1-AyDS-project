class CreateProgressiveTable < ActiveRecord::Migration[7.1]
  def change
    create_table :progressives do |t|
      t.string :name_theme
    end
  end
end
