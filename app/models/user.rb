class User < ApplicationRecord
  has_secure_password

  before_create :generate_confirmation_token

  validates :username, presence: true, uniqueness: true, length: { in: 3..20 }, format: { with: /\A[a-zA-Z0-9_]+\z/ }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true
  validate :validate_password_strength
  def confirmed?
    confirmed_at.present?
  end

  def confirm!
    update_columns(confirmed_at: Time.current, confirmation_token: nil)
  end

  def reset_password_period_valid?
    reset_password_sent_at.present? && reset_password_sent_at > 2.hours.ago
  end

  def generate_reset_password_token!
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_sent_at = Time.current
    save(validate: false)
  end

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.hex(10)
    self.confirmation_sent_at = Time.current
  end

  private
  def validate_password_strength
    if password.length < 8 || password.length > 128
      errors.add(:password, "Пароль должен содержать не менее 8 символов и не более 128 символов")
    end

    unless password.match?(/\d/)
      errors.add(:password, "Пароль должен содержать хотя бы одну цифру")
    end

    unless password.match?(/[a-zа-я]/)
      errors.add(:password, "Пароль должен содержать хотя бы одну строчную букву")
    end

    unless password.match?(/[A-ZА-Я]/)
      errors.add(:password, "Пароль должен содержать хотя бы одну заглавную букву")
    end
  end
end
