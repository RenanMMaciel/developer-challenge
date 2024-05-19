class RenameOrderColumn < ActiveRecord::Migration[7.1]
  def change
    rename_column :orders, :order, :components
  end
end
