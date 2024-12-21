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

  def reset_password_period_valid?
    reset_password_sent_at.present? && reset_password_sent_at > 2.hours.ago
  end

  # private
  def generate_reset_password_token!
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_sent_at = Time.current
    save(validate: false)
  end

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.hex(10)
    self.confirmation_sent_at = Time.current
  end
end
