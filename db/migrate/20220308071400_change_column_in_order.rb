class ChangeColumnInOrder < ActiveRecord::Migration[6.1]
  def change
    rename_column :orders, :address, :feedback
  end
end
