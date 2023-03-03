class BulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.string :name
      t.float :percentage_discount
      t.integer :quantity_threshold
      t.belongs_to :merchant

      t.timestamps
    end
  end
end
