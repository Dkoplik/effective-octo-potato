require 'rails_helper'

RSpec.describe "Users API", type: :request do
  describe "POST /users" do
    it "creates a new user with valid data" do
      post "/users", params: {
        username: "testuser",
        email: "testuser@example.com",
        password: "SecurePass123!"
      }, as: :json

      expect(response).to have_http_status(:created)
    end

    it "returns an error with invalid data" do
      post "/users", params: { username: "", email: "invalid", password: "short" }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "POST /login" do
    let!(:user) { User.create(username: "testuser", email: "testuser@example.com", password: "SecurePass123!") }

    it "logs in with valid credentials" do
      post "/login", params: { username: "testuser", password: "SecurePass123!" }, as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Login successful")
    end

    it "fails with invalid credentials" do
      post "/login", params: { username: "testuser", password: "WrongPass" }, as: :json

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)["error"]).to eq("Invalid username or password")
    end
  end

  describe "POST /password_resets" do
    let!(:user) { User.create(username: "testuser", email: "testuser@example.com", password: "SecurePass123!") }

    it "initiates password reset for a valid user" do
      post "/password_resets", params: { username: "testuser" }, as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Password reset instructions have been sent to your email")
    end
  end

  describe "POST /delete_account" do
    let!(:user) { User.create(username: "testuser", email: "testuser@example.com", password: "SecurePass123!") }

    it "deletes an account with valid credentials" do
      post "/delete_account", params: { username: "testuser", password: "SecurePass123!" }, as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Account deleted successfully")
      expect(User.find_by(username: "testuser")).to be_nil
    end
  end
end
