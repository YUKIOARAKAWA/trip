class CreatePins < ActiveRecord::Migration
  def change
    create_table :pins do |t|
      t.references :place, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :comment
      t.integer :want

      t.timestamps null: false
    end
  end
end
