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
TestsUser.delete_all
Test.delete_all
Category.delete_all
User.delete_all

ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='categories'")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='users'")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='tests'")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='tests_users'")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='questions'")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='answers'")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='results'")

categories = Category.create!([{ title: 'Math' }, { title: 'History' }, { title: 'Geography' }])

users = User.create!([{ name: 'Admin' }, { name: 'User1' }, { name: 'User2' }])

tests = 10.times.map do |i|
  Test.create!(
    title: "Test #{i + 1}",
    level: rand(1..3),
    category_id: categories.sample.id,
    author_id: User.find_by!(name: 'Admin').id
  )
end

allowed_users = User.where.not(name: 'Admin')

allowed_users.each do |user|
  tests.each do |test|
    user.tests << test
  end
end

# constant array needs a mutable copy to work with .shift
question_templates = [
  'What is the capital of France?',
  'How many continents are there?',
  'What is the square root of 64?',
  'Name the largest ocean on Earth.',
  'Who wrote "To Kill a Mockingbird"?',
  'What year did World War II end?',
  'What is the boiling point of water?',
  'Who painted the Mona Lisa?',
  'What is the speed of light?',
  'Which planet is known as the Red Planet?',
  'Who developed the theory of relativity?',
  'What gas do humans breathe in to survive?',
  'What is the largest mammal on Earth?',
  'Who was the first man on the moon?',
  'What is the chemical symbol for gold?',
  'How many days are there in a leap year?',
  'What is the smallest prime number?',
  'What is the largest desert in the world?',
  'Which country is known for the maple leaf?',
  'What is the tallest mountain in the world?',
  'What is the hardest natural substance?',
  'What is the currency of Japan?',
  'Who invented the telephone?',
  'What is the longest river in the world?',
  'How many teeth does an adult human have?',
  'What is the fastest land animal?',
  'Who is known as the "Father of Computers"?',
  'What is the main language spoken in Brazil?',
  'What is the freezing point of water?',
  'Which planet is closest to the sun?'
]
# .dup inside block keeps creating fresh copies
available_questions = question_templates.dup

questions = tests.flat_map do |test|
  selected_questions = available_questions.shift(3)

  raise 'Not enough unique questions for all tests' if selected_questions.size < 3

  selected_questions.map do |question_body|
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
  'Who wrote "To Kill a Mockingbird"?' => 'Harper Lee',
  'What year did World War II end?' => '1945',
  'What is the boiling point of water?' => '100°C',
  'Who painted the Mona Lisa?' => 'Leonardo da Vinci',
  'What is the speed of light?' => '299,792,458 meters per second',
  'Which planet is known as the Red Planet?' => 'Mars',
  'Who developed the theory of relativity?' => 'Albert Einstein',
  'What gas do humans breathe in to survive?' => 'Oxygen',
  'What is the largest mammal on Earth?' => 'Blue Whale',
  'Who was the first man on the moon?' => 'Neil Armstrong',
  'What is the chemical symbol for gold?' => 'Au',
  'How many days are there in a leap year?' => '366',
  'What is the smallest prime number?' => '2',
  'What is the largest desert in the world?' => 'Antarctic Desert',
  'Which country is known for the maple leaf?' => 'Canada',
  'What is the tallest mountain in the world?' => 'Mount Everest',
  'What is the hardest natural substance?' => 'Diamond',
  'What is the currency of Japan?' => 'Yen',
  'Who invented the telephone?' => 'Alexander Graham Bell',
  'What is the longest river in the world?' => 'Nile River',
  'How many teeth does an adult human have?' => '32',
  'What is the fastest land animal?' => 'Cheetah',
  'Who is known as the "Father of Computers"?' => 'Charles Babbage',
  'What is the main language spoken in Brazil?' => 'Portuguese',
  'What is the freezing point of water?' => '0°C',
  'Which planet is closest to the sun?' => 'Mercury'
}

incorrect_answers = {
  'What is the capital of France?' => %w[London Berlin Rome],
  'How many continents are there?' => %w[6 8 9],
  'What is the square root of 64?' => %w[7 9 10],
  'Name the largest ocean on Earth.' => ['Atlantic Ocean', 'Indian Ocean', 'Arctic Ocean'],
  'Who wrote "To Kill a Mockingbird"?' => ['J.K. Rowling', 'Stephen King', 'George Orwell'],
  'What year did World War II end?' => %w[1944 1946 1948],
  'What is the boiling point of water?' => %w[99°C 101°C 102°C],
  'Who painted the Mona Lisa?' => ['Vincent van Gogh', 'Pablo Picasso', 'Salvador Dalí'],
  'What is the speed of light?' => ['300,000,000 meters per second', '293,791,488 meters per second', '219,790,456 meters per second'],
  'Which planet is known as the Red Planet?' => %w[Venus Jupiter Saturn],
  'Who developed the theory of relativity?' => ['Isaac Newton', 'Nikola Tesla', 'Galileo Galilei'],
  'What gas do humans breathe in to survive?' => ['Carbon Dioxide', 'Nitrogen', 'Helium'],
  'What is the largest mammal on Earth?' => ['Elephant', 'Hippopotamus', 'Whale Shark'],
  'Who was the first man on the moon?' => ['Buzz Aldrin', 'Yuri Gagarin', 'Michael Collins'],
  'What is the chemical symbol for gold?' => %w[Ag Fe Pb],
  'How many days are there in a leap year?' => %w[365 364 367],
  'What is the smallest prime number?' => %w[1 3 5],
  'What is the largest desert in the world?' => ['Sahara Desert', 'Gobi Desert', 'Kalahari Desert'],
  'Which country is known for the maple leaf?' => %w[USA Australia UK],
  'What is the tallest mountain in the world?' => %w[K2 Kangchenjunga Lhotse],
  'What is the hardest natural substance?' => %w[Steel Graphite Quartz],
  'What is the currency of Japan?' => %w[Won Dollar Ruble],
  'Who invented the telephone?' => ['Thomas Edison', 'Nikola Tesla', 'Guglielmo Marconi'],
  'What is the longest river in the world?' => ['Amazon River', 'Yangtze River', 'Mississippi River'],
  'How many teeth does an adult human have?' => %w[30 28 34],
  'What is the fastest land animal?' => %w[Leopard Lion Tiger],
  'Who is known as the "Father of Computers"?' => ['Alan Turing', 'John von Neumann', 'Steve Jobs'],
  'What is the main language spoken in Brazil?' => %w[Spanish French English],
  'What is the freezing point of water?' => %w[-1°C 1°C -5°C],
  'Which planet is closest to the sun?' => %w[Venus Earth Mars]
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
