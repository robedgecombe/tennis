class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
    	t.integer :score, default: 0
    	t.integer :you_id
    	t.integer :him_id

      t.timestamps
    end
  end
end
