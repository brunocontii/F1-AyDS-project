class CreateFreeTable < ActiveRecord::Migration[7.1]
  def change
    create_table :frees do |t|
      t.string :name_level
    end
  end
end
