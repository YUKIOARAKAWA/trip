class CreatePlanUsers < ActiveRecord::Migration
  def change
    create_table :plan_users do |t|
      t.references :plan, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
