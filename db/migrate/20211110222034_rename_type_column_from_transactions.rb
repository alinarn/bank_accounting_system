class RenameTypeColumnFromTransactions < ActiveRecord::Migration[6.0]
  def change
    rename_column :transactions, :type, :status
  end
end
