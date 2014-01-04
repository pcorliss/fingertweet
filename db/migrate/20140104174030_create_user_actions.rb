class CreateUserActions < ActiveRecord::Migration
  def change
    create_table :user_actions do |t|
      t.string :twitter_user
      t.string :action
      t.text :content
      t.boolean :past_tense

      t.timestamps
    end
  end
end
