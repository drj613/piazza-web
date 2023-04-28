require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:jerry)
  end

  test "user is logged in an redirected to root with correct credentials" do
    assert_difference("@user.app_sessions.count", 1) do
      post login_path, params: {
        user: {
          email: "jerry@example.com",
          password: "password"
        }
      }
    end

    assert_redirected_to root_path
  end

  test "error is rendered for login with incorrect credentials" do
    post login_path, params: {
      user: {
        email: "wrong@example.com",
        password: "password"
      }
    }

    assert_select ".notification",
      I18n.t("sessions.create.incorrect_details")
  end
end
