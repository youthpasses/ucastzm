class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :post_id
      t.integer :from_user_id
      t.integer :to_user_id
      t.text :content

      t.timestamps null: false
    end
  end
end
