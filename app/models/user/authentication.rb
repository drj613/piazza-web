module User::Authentication
  extend ActiveSupport::Concern

  included do
    has_secure_password
    validates :password,
              presence: true,
              length:   { minimum: 8 }
    # password_confirmation is included in `has_secure_password by default`
    #  but this manual validation checks against that field being blank
    validates :password_confirmation, presence: true

    has_many :app_sessions, dependent: :destroy
  end
end
