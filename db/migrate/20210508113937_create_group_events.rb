class CreateGroupEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :group_events do |t|
      t.string :name, null: false
      t.text :description
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :zipcode
      t.string :status, null: false
      t.boolean :deleted, null: false, default: false
      t.date :start_date
      t.date :end_date
      t.integer :duration
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
