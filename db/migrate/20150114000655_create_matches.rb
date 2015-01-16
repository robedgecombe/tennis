class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
    	t.integer :score, default: 0

      t.timestamps
    end
  end
end
