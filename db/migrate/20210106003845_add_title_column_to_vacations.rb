class AddTitleColumnToVacations < ActiveRecord::Migration
  def change
    add_column :vacations, :title, :string
  end
end
