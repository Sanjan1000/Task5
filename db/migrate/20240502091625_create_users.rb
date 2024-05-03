class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :identifier
      t.string :name
      t.string :address
      t.string :phone
      t.string :seed

      t.timestamps
    end
  end
end
