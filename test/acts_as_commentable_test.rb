require 'test_helper'

class ActsAsCommentableTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, ActsAsCommentable
  end
end
