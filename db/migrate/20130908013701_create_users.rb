class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :complete_name
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
