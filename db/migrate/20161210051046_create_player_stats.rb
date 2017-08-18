class CreatePlayerStats < ActiveRecord::Migration
  def change
    create_table :player_stats do |t|
    	t.string  :name
      t.integer :energy, default: 200
      t.integer :confidence
      t.integer :concentration
      t.integer :intelligence
      t.integer :power
      t.integer :speed
      t.integer :backhand
      t.integer :accuracy
      t.integer :net_ability
      t.integer :drop_shot
      t.integer :first_serve
      t.integer :second_serve
      t.integer :return
    end
  end
end
