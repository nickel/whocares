require "test_helper"

class UserAuthenticationTest < ActionDispatch::IntegrationTest
  test "can view sign up page" do
    get new_user_registration_path
    assert_response :success
    assert_select "h2", "Sign up"
  end

  test "can view log in page" do
    get new_user_session_path
    assert_response :success
    assert_select "h2", "Log in"
  end

  test "can sign up with valid data" do
    assert_difference("User.count", 1) do
      post user_registration_path, params: {
        user: {
          email: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    assert_response :redirect
    follow_redirect!
    assert_select ".bg-green-100"
  end

  test "cannot sign up with invalid data" do
    assert_no_difference("User.count") do
      post user_registration_path, params: {
        user: {
          email: "invalid",
          password: "123",
          password_confirmation: "456"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "can log in with valid credentials" do
    user = User.create!(email: "test@example.com", password: "password123")
    post user_session_path, params: {
      user: {
        email: user.email,
        password: "password123"
      }
    }
    assert_response :redirect
  end

  test "cannot log in with invalid credentials" do
    User.create!(email: "test@example.com", password: "password123")
    post user_session_path, params: {
      user: {
        email: "test@example.com",
        password: "wrongpassword"
      }
    }
    assert_response :unprocessable_entity
  end

  test "can log out" do
    user = User.create!(email: "test@example.com", password: "password123")
    post user_session_path, params: {
      user: { email: user.email, password: "password123" }
    }
    delete destroy_user_session_path
    assert_response :redirect
  end
end
