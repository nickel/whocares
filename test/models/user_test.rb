require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user without email" do
    user = User.new(password: "password123")
    assert_not user.save, "Saved user without email"
  end

  test "should not save user without password" do
    user = User.new(email: "test@example.com")
    assert_not user.save, "Saved user without password"
  end

  test "should not save user with invalid email" do
    user = User.new(email: "invalid", password: "password123")
    assert_not user.save, "Saved user with invalid email"
  end

  test "should not save user with short password" do
    user = User.new(email: "test@example.com", password: "12345")
    assert_not user.save, "Saved user with password less than 6 characters"
  end

  test "should save valid user" do
    user = User.new(email: "valid@example.com", password: "password123")
    assert user.save, "Could not save valid user"
  end

  test "should not save duplicate email" do
    User.create!(email: "duplicate@example.com", password: "password123")
    user = User.new(email: "duplicate@example.com", password: "password123")
    assert_not user.save, "Saved user with duplicate email"
  end
end
