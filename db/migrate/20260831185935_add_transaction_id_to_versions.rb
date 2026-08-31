class AddTransactionIdToVersions < ActiveRecord::Migration[8.1]
  def change
    add_column :versions, :transaction_id, :bigint
    add_index :versions, :transaction_id
  end
end
