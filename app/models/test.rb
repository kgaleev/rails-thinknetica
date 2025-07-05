class Test < ApplicationRecord
  has_many :tests_users
  has_many :users, through: :tests_users
  has_many :questions
  belongs_to :category
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  def self.test_title_desc(title)
    joins('JOIN categories ON tests.category_id = categories.id')
      .where(categories: { title: })
      .order(title: :desc)
      .pluck(:title)
  end
end
