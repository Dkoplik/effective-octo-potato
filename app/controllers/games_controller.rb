class GamesController < ApplicationController
  def create
    player1_id = params[:player1_id]
    player2_id = params[:player2_id]

    if player1_id.nil? || player2_id.nil?
      render json: { error: "Both player1_id and player2_id are required" }, status: :unprocessable_entity
      return
    end


    if player1_id == player2_id
      render json: { error: "Player 1 and Player 2 cannot have the same ID" }, status: :unprocessable_entity
      return
    end

    unless User.exists?(id: player1_id)
      render json: { error: "Player 1 with ID #{player1_id} does not exist" }, status: :not_found
      return
    end

    unless User.exists?(id: player2_id)
      render json: { error: "Player 2 with ID #{player2_id} does not exist" }, status: :not_found
      return
    end

    game = Game.new(
      player1_id: player1_id,
      player2_id: player2_id,
      created_at: Time.current
    )

    if game.save
      render json: { message: "Game created successfully", game_id: game.id }, status: :created
    else
      render json: { error: "Failed to create game", details: game.errors.full_messages }, status: :unprocessable_entity
    end
  end

def start
  game = Game.find_by(id: params[:id])

  if game.nil?
    render json: { error: "Game not found" }, status: :not_found
    return
  end

  if game.started_at.present?
    render json: { error: "Game has already started" }, status: :unprocessable_entity
    return
  end

  game.started_at = Time.current

  if game.save
    render json: { message: "Game started successfully", game_id: game.id }, status: :ok
  else
    render json: { error: "Failed to update game", details: game.errors.full_messages }, status: :unprocessable_entity
  end
end
end
