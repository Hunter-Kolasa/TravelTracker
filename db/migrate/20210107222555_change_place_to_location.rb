class ChangePlaceToLocation < ActiveRecord::Migration
  def change
    rename_column :vacations, :place, :location
  end
end
