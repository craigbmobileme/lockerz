class CreateLockers < ActiveRecord::Migration
  def change
    create_table :lockers do |t|
    	t.string :code
    	t.integer :bag_size
      t.integer :size
      t.integer :number
      t.timestamps
    end
  end
end
