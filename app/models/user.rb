class User < ApplicationRecord
  has_secure_password

  before_create :generate_confirmation_token

  validates :username, presence: true, uniqueness: true, length: { in: 3..20 }, format: { with: /\A[a-zA-Z0-9_]+\z/ }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { in: 8..128 }, format: { with: /\A(?=.*[a-zа-я])(?=.*[A-ZА-Я])(?=.*\d)(?=.*[~!?@#$%^&*_\-+()\[\]{}><\/\\|"'.,:;])[a-zA-Zа-яА-Я\d~!?@#$%^&*_\-+()\[\]{}><\/\\|"'.,:;]+\z/ }

  def confirmed?
    confirmed_at.present?
  end

  def confirm!
    update_columns(confirmed_at: Time.current, confirmation_token: nil)
  end

  private

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.hex(10)
    self.confirmation_sent_at = Time.current
  end
end
