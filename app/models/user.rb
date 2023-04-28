class User < ApplicationRecord
  include Authentication
  # ---- VALIDATIONS
  validates :name, presence: true
  validates :email,
            format:     { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false }

  before_validation :strip_extraneous_spaces
  # ---- END VALIDATIONS

  # ---- ASSOCIATIONS
  #  corresponding memberships will be destroyed when their user is destroyed
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  # ---- END ASSOCIATIONS

  def self.create_app_session(email:, password:)
    return nil unless (user = User.find_by(email: email.downcase))

    user.app_sessions.create if user.authenticate(password)
  end

  def authenticate_app_session(app_session_id, token)
    app_sessions.find(app_session_id).authenticate_token(token)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  private

  def strip_extraneous_spaces
    # self.name = self.name&.strip
    self.name = name&.strip
    self.email = email&.strip
  end
end
