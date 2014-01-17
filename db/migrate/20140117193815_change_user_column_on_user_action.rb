class ChangeUserColumnOnUserAction < ActiveRecord::Migration
  def change
    change_table :user_actions do |t|
      t.remove :twitter_user
      t.integer :user_id
    end
  end
end
