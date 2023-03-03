RSpec.describe "" do
  it "" do
    before do
      @merchant1 = Merchant.create!(name: "Sally's", status: 0)
      @merchant2 = Merchant.create!(name: "Bobby's", status: 1)
      @bulk_discount1 = BulkDiscount.create!(name: "20% off 10", percentage_discount: 0.20, quantity_threshold: 10, merchant_id: @merchant1.id)
      @bulk_discount2 = BulkDiscount.create!(name: "30% off 15", percentage_discount: 0.30, quantity_threshold: 15, merchant_id: @merchant1.id)
      @bulk_discount3 = BulkDiscount.create!(name: "15% off 25", percentage_discount: 0.15, quantity_threshold: 25, merchant_id: @merchant2.id)
    end
  end
end
