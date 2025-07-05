class User < ApplicationRecord
  has_many :created_tests, class_name: 'Test', foreign_key: 'author_id'
  has_many :tests_users
  has_many :tests, through: :tests_users
  def list_tests(level)
    Test.joins("JOIN results ON results.test_id = tests.id")
        .where('results.user_id = ? AND tests.level = ?', id, level)
  end
end
