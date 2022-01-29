class CreateDiagnoses < ActiveRecord::Migration[7.0]
  def change
    create_table :diagnoses do |t|
      t.string :code, limit: 7
      t.string :description
      t.integer :icd_type, default: 10
      t.string :full_code, limit: 10
      t.references :category, foreign_key: true, null: false
      t.timestamps
    end

    add_index :diagnoses, :full_code, unique: true
  end
end
