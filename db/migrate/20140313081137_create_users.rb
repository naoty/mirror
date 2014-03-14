class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :access_token
      t.string :remember_token
    end
  end
end
