class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.text :body, null: false
      t.boolean :correct, default: false, null: false
      t.references :question, null: false, foreign_key: true
      t.timestamps
    end
  end
end
