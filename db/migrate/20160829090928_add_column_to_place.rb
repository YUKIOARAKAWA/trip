class AddColumnToPlace < ActiveRecord::Migration
  def change
    add_column :places, :from, :datetime
    add_column :places, :to, :datetime
  end
end
