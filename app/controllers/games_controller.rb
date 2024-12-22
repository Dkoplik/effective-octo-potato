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

    # Проверка, что игроки не находятся в активной игре
    active_game_player1 = Game.where(player1_id: player1_id).or(Game.where(player2_id: player1_id)).where(ended_at: nil).exists?
    active_game_player2 = Game.where(player1_id: player2_id).or(Game.where(player2_id: player2_id)).where(ended_at: nil).exists?

    if active_game_player1 || active_game_player2
      render json: { error: "One or both players are already in an active game" }, status: :unprocessable_entity
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

def update
  game = Game.find_by(id: params[:id])

  if game.nil?
    render json: { error: "Game with ID #{params[:id]} not found" }, status: :not_found
    return
  end

  if game.ended_at.present?
    render json: { error: "Game with ID #{params[:id]} is already completed" }, status: :unprocessable_entity
    return
  end

  winner_id = params[:winner_id]
  ended_at = params[:ended_at] || Time.current

  unless [ game.player1_id, game.player2_id ].include?(winner_id.to_i)
    render json: { error: "Winner ID #{winner_id} is not a participant in this game" }, status: :unprocessable_entity
    return
  end

  if game.update(winner_id: winner_id, ended_at: ended_at)
    render json: { message: "Game updated successfully", game: game }, status: :ok
  else
    render json: { error: "Failed to update game", details: game.errors.full_messages }, status: :unprocessable_entity
  end
end

def show
  game = Game.find(params[:id])

  player1 = User.find(game.player1_id)
  player2 = User.find(game.player2_id)

  render json: {
    game_id: game.id,
    player1: player1.username,
    player2: player2.username,
    winner: (game.winner_id ? User.find(game.winner_id).username : nil),
    started_at: game.started_at,
    ended_at: game.ended_at
  }
rescue ActiveRecord::RecordNotFound
  render json: { error: "Game not found" }, status: :not_found
end
end
