class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
    	t.string  :status, default: "new"
    	t.integer :player_1_id
    	t.integer :player_2_id
    	t.integer :winner_id
    	t.integer :loser_id
    	t.integer :venue_id
    	t.string  :type

      t.timestamps
    end
  end
end
