class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :code, limit: 6
      t.string :title, limit: 200, null: true

      t.timestamps
    end

    add_index :categories, :code, unique: true
  end
end
