class CreateComponents < ActiveRecord::Migration[7.1]
  def change
    create_table :components do |t|
      t.string :name
      t.integer :component_type
      t.json :specifications

      t.timestamps
    end
  end
end
