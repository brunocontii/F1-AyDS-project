class CreateFreeTable < ActiveRecord::Migration[7.1]
  def change
    create_table :frees do |t|
      t.string :name_level
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
