class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.integer :player1_id
      t.integer :player2_id
      t.integer :winner_id
      t.timestamp :started_at
      t.timestamp :ended_at
      t.timestamp :created_at
    end
  end
end
