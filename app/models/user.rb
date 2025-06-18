class User < ApplicationRecord
  def list_tests(level)
    Test.joins("JOIN results ON results.test_id = tests.id")
        .where('results.user_id = ? AND tests.level = ?', id, level)
  end
end
