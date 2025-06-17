class User < ApplicationRecord
  def list_tests(level)
    #Test.where('level = ? AND author_id = ?', level, id)
    Test.joins('JOIN users ON tests.author_id = users.id')
        .where('users.id = ? AND tests.level = ?', id, level)
  end
end
