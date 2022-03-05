require 'test_helper'

class User::InformationsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get user_informations_show_url
    assert_response :success
  end

  test "should get edit" do
    get user_informations_edit_url
    assert_response :success
  end

  test "should get unsubscribe" do
    get user_informations_unsubscribe_url
    assert_response :success
  end

end
