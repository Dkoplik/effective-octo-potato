require 'rails_helper'

RSpec.describe "Games API", type: :request do
  describe "POST /games" do
    let!(:player1) { User.create(username: "player1", email: "player1@example.com", password: "SecurePass123!") }
    let!(:player2) { User.create(username: "player2", email: "player2@example.com", password: "SecurePass123!") }
    it "creates a game with valid players" do
      post "/games", params: { player1_id: player1.id, player2_id: player2.id }, as: :json

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["message"]).to eq("Game created successfully")
      expect(JSON.parse(response.body)["game_id"]).to be_present
    end

    it "returns an error if players are the same" do
      post "/games", params: { player1_id: player1.id, player2_id: player1.id }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["error"]).to eq("Player 1 and Player 2 cannot have the same ID")
    end

    it "returns an error if one of the players does not exist" do
      post "/games", params: { player1_id: player1.id, player2_id: 9999 }, as: :json

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Player 2 with ID 9999 does not exist")
    end

    it "returns an error if one or both players are already in an active game" do
      Game.create(player1_id: player1.id, player2_id: player2.id)
      post "/games", params: { player1_id: player1.id, player2_id: player2.id }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["error"]).to eq("One or both players are already in an active game")
    end
  end

  describe "PATCH /games/:id/start" do
    let!(:player1) { User.create(username: "player1", email: "player1@example.com", password: "SecurePass123!") }
    let!(:player2) { User.create(username: "player2", email: "player2@example.com", password: "SecurePass123!") }
    let!(:game) { Game.create(player1_id: player1.id, player2_id: player2.id) }
    it "starts a game successfully" do
      patch "/games/#{game.id}/start", as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Game started successfully")
    end
  end

  describe "PATCH /games/:id" do
    let!(:player1) { User.create(username: "player1", email: "player1@example.com", password: "SecurePass123!") }
    let!(:player2) { User.create(username: "player2", email: "player2@example.com", password: "SecurePass123!") }
    let!(:game) { Game.create(player1_id: player1.id, player2_id: player2.id) }
    it "updates a game with a winner" do
      patch "/games/#{game.id}", params: { winner_id: player1.id }, as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Game updated successfully")
      expect(game.reload.winner_id).to eq(player1.id)
    end
  end

  describe "GET /games/:id" do
    let!(:player1) { User.create(username: "player1", email: "player1@example.com", password: "SecurePass123!") }
    let!(:player2) { User.create(username: "player2", email: "player2@example.com", password: "SecurePass123!") }
    let!(:game) { Game.create(player1_id: player1.id, player2_id: player2.id) }
    it "retrieves game information" do
      get "/games/#{game.id}", as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["game_id"]).to eq(game.id)
      expect(JSON.parse(response.body)["player1"]).to eq(player1.username)
      expect(JSON.parse(response.body)["player2"]).to eq(player2.username)
    end
  end
end
