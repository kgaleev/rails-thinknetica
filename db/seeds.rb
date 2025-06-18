# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Result.delete_all
Answer.delete_all
Question.delete_all
Test.delete_all
Category.delete_all
User.delete_all

ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='categories'")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='users'")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='tests'")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='questions'")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='answers'")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='results'")

categories = Category.create!([{ title: 'Math' }, {title: 'History'}, {title: 'Geography'}])

users = User.create!([{ name: 'Admin' }, { name: 'User1' }, { name: 'User2' }])

tests = 10.times.map do |i|
  Test.create!(
    title: "Test #{i + 1}",
    level: rand(1..3),
    category_id: categories.sample.id,
    author_id: User.find_by!(name: 'Admin').id
  )
end

question_templates = [
  'What is the capital of France?',
  'How many continents are there?',
  'What is the square root of 64?',
  'Name the largest ocean on Earth.',
  "Who wrote 'To Kill a Mockingbird'?",
  'What year did World War II end?',
  'What is the boiling point of water?',
  'Who painted the Mona Lisa?',
  'What is the speed of light?'
]

questions = tests.flat_map do |test|
  question_templates.sample(3).map do |question_body|
    Question.create!(
      body: question_body,
      test_id: test.id
    )
  end
end

correct_answers = {
  'What is the capital of France?' => 'Paris',
  'How many continents are there?' => '7',
  'What is the square root of 64?' => '8',
  'Name the largest ocean on Earth.' => 'Pacific Ocean',
  "Who wrote 'To Kill a Mockingbird'?" => 'Harper Lee',
  'What year did World War II end?' => '1945',
  'What is the boiling point of water?' => '100°C',
  'Who painted the Mona Lisa?' => 'Leonardo da Vinci',
  'What is the speed of light?' => '299,792,458 meters per second'
}

incorrect_answers = {
  'What is the capital of France?' => ['London', 'Berlin', 'Rome'],
  'How many continents are there?' => ['6', '8', '9'],
  'What is the square root of 64?' => ['7', '9', '10'],
  'Name the largest ocean on Earth.' => ['Atlantic Ocean', 'Indian Ocean', 'Arctic Ocean'],
  "Who wrote 'To Kill a Mockingbird'?" => ['J.K. Rowling', 'Stephen King', 'George Orwell'],
  'What year did World War II end?' => ['1944', '1946', '1948'],
  'What is the boiling point of water?' => ['99°C', '101°C', '102°C'],
  'Who painted the Mona Lisa?' => ['Vincent van Gogh', 'Pablo Picasso', 'Salvador Dalí'],
  'What is the speed of light?' => ['300,000,000 meters per second', '293,791,488 meters per second', '219,790,456 meters per second']
}

answers = questions.each do |question|
  body = question.body

  Answer.create!(
    body: correct_answers[body],
    correct: true,
    question_id: question.id
  )

  incorrect_answers[body].each do |incorrect|
    Answer.create!(
      body: incorrect,
      correct: false,
      question_id: question.id
    )
  end
end

results = tests.each do |test|
  user = users.sample
  score = rand(0..3)

  Result.create!(
    user_id: user.id,
    test_id: test.id,
    score:
  )
end
