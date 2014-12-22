class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.integer :energy
      t.integer :confidence
      t.integer :concentration
      t.integer :intellegence
      t.integer :power
      t.integer :speed
      t.integer :backhand
      t.integer :accuracy
      t.integer :net_ability
      t.integer :drop_shot
      t.integer :first_serve
      t.integer :second_serve
      t.integer :return

      t.timestamps
    end
  end
end
