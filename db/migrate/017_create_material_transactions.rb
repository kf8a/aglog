class CreateMaterialTransactions < ActiveRecord::Migration
  def self.up
    create_table :material_transactions do |t|
      t.column :material_id, :integer
      t.column :unit_id, :integer
      t.column :setup_id,  :integer
      t.column :rate, :float
      t.column :cents, :integer
      t.column :material_transaction_type_id,  :integer
      t.column :transaction_datetime,  :datetime
    end
  end

  def self.down
    drop_table :material_transactions
  end
end
