require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should validate_presence_of :dailymile_id
  should have_many :activities

  context 'a new user' do
    setup do
      @user = User.make!
    end

    should validate_uniqueness_of :dailymile_id

    should 'be active' do
      assert @user.active?
    end
  end
end
