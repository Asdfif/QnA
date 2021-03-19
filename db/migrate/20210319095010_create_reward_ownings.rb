class CreateRewardOwnings < ActiveRecord::Migration[6.1]
  def change
    create_table :reward_ownings do |t|
      t.references  :reward, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
