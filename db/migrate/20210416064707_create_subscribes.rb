class CreateSubscribes < ActiveRecord::Migration[6.1]
  def change
    create_table :subscribes do |t|
      t.references :user, foreign_key: true, null: false
      t.references :question, foreign_key: true, null: false
      
      t.timestamps
    end
  end
end
