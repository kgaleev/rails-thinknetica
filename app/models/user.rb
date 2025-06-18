class User < ApplicationRecord
  def list_tests(level)
    Result.joins(:test)
          .where(tests: { level: }, user_id: id)
  end
end
