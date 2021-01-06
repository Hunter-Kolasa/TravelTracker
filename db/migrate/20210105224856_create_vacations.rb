class CreateVacations < ActiveRecord::Migration
  def change
    create_table :vacations do |t|
      t.integer :user_id
      t.string :place
      t.string :date
      t.string :description
    end
  end
end
