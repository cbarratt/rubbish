class CreateCollections < ActiveRecord::Migration[5.2]
  def change
    create_table :collections do |t|
      t.text :postcode
      t.date :date
      t.integer :bin_type

      t.timestamps
    end
  end
end
