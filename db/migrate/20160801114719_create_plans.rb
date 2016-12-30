class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.references :area, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
