class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :twitter_user
      t.string :avatar_uri

      t.timestamps
    end
  end
end
