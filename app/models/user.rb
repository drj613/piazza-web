class User < ApplicationRecord
  # ---- VALIDATIONS
  validates :name, presence: true
  validates :email,
            format:     { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false }

  before_validation :strip_extraneous_spaces

  has_secure_password
  validates :password,
            presence: true,
            length:   { minimum: 8 }
  # password_confirmation is included in `has_secure_password by default`
  #  but this manual validation checks against that field being blank
  validates :password_confirmation, presence: true

  # ---- END VALIDATIONS

  # ---- ASSOCIATIONS
  #  corresponding memberships will be destroyed when their user is destroyed
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :app_sessions, dependent: :destroy
  # ---- END ASSOCIATIONS

  # ---- SCOPES

  # ---- END SCOPES

  def self.create_app_session(email:, password:)
    return nil unless (user = User.find_by(email: email.downcase))

    user.app_sessions.create if user.authenticate(password)
  end

  private

  def strip_extraneous_spaces
    # self.name = self.name&.strip
    self.name = name&.strip
    self.email = email&.strip
  end
end
