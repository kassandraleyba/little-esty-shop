require 'rails_helper'

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
end

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many :bulk_discounts }
  end

  describe 'instance methods' do
    let!(:merchant1) { create(:merchant) }
    let!(:merchant2) { create(:merchant) }
    let!(:customer1) { create(:customer) }
    let!(:customer2) { create(:customer) }
    let!(:customer3) { create(:customer) }
    let!(:customer4) { create(:customer) }
    let!(:customer5) { create(:customer) }
    let!(:customer6) { create(:customer) }
    let!(:invoice1) { create(:invoice, customer_id: customer1.id) }
    let!(:invoice2) { create(:invoice, customer_id: customer1.id) }
    let!(:invoice3) { create(:invoice, customer_id: customer1.id) }
    let!(:invoice4) { create(:invoice, customer_id: customer2.id) }
    let!(:invoice5) { create(:invoice, customer_id: customer2.id) }
    let!(:invoice6) { create(:invoice, customer_id: customer2.id) }
    let!(:invoice7) { create(:invoice, customer_id: customer3.id) }
    let!(:invoice8) { create(:invoice, customer_id: customer3.id) }
    let!(:invoice9) { create(:invoice, customer_id: customer4.id) }
    let!(:invoice10) { create(:invoice, customer_id: customer5.id) }
    let!(:invoice11) { create(:invoice, customer_id: customer6.id) }
    let!(:item1) { create(:item, merchant_id: merchant1.id)}
    let!(:item2) { create(:item, merchant_id: merchant1.id)}
    let!(:item3) { create(:item, merchant_id: merchant1.id)}
    let!(:item4) { create(:item, merchant_id: merchant1.id)}
    let!(:item5) { create(:item, merchant_id: merchant1.id)}
    let!(:item6) { create(:item, merchant_id: merchant1.id)}
    let!(:item7) { create(:item, merchant_id: merchant1.id)}
    let!(:item8) { create(:item, merchant_id: merchant1.id)}
    let!(:item9) { create(:item, merchant_id: merchant1.id)}
    let!(:item10) { create(:item, merchant_id: merchant1.id)}
    let!(:item11) { create(:item, merchant_id: merchant1.id)}
    let!(:transaction1) { create(:transaction, invoice_id: invoice1.id, result: "success")}
    let!(:transaction2) { create(:transaction, invoice_id: invoice2.id, result: "success")}
    let!(:transaction3) { create(:transaction, invoice_id: invoice3.id, result: "success")}
    let!(:transaction4) { create(:transaction, invoice_id: invoice4.id, result: "success")}
    let!(:transaction5) { create(:transaction, invoice_id: invoice4.id, result: "success")}
    let!(:transaction6) { create(:transaction, invoice_id: invoice5.id, result: "success")}
    let!(:transaction7) { create(:transaction, invoice_id: invoice6.id, result: "success")}
    let!(:transaction8) { create(:transaction, invoice_id: invoice7.id, result: "success")}
    let!(:transaction9) { create(:transaction, invoice_id: invoice7.id, result: "success")}
    let!(:transaction10) { create(:transaction, invoice_id: invoice8.id, result: "success")}
    let!(:transaction11) { create(:transaction, invoice_id: invoice8.id, result: "success")}
    let!(:transaction12) { create(:transaction, invoice_id: invoice9.id, result: "success")}
    let!(:transaction13) { create(:transaction, invoice_id: invoice10.id, result: "success")}
    let!(:transaction14) { create(:transaction, invoice_id: invoice10.id, result: "success")}
    let!(:transaction15) { create(:transaction, invoice_id: invoice11.id, result: "failed")}
    let!(:transaction16) { create(:transaction, invoice_id: invoice11.id, result: "failed")}
    let!(:transaction17) { create(:transaction, invoice_id: invoice7.id, result: "failed")}
    let!(:transaction18) { create(:transaction, invoice_id: invoice2.id, result: "failed")}

    before do
      InvoiceItem.create!(item_id: item1.id, invoice_id: invoice1.id, status: "packaged") 
      InvoiceItem.create!(item_id: item2.id, invoice_id: invoice2.id, status: "pending") 
      InvoiceItem.create!(item_id: item3.id, invoice_id: invoice3.id, status: "shipped") 
      InvoiceItem.create!(item_id: item4.id, invoice_id: invoice4.id, status: "packaged") 
      InvoiceItem.create!(item_id: item5.id, invoice_id: invoice5.id, status: "pending") 
      InvoiceItem.create!(item_id: item6.id, invoice_id: invoice6.id, status: "pending") 
      InvoiceItem.create!(item_id: item7.id, invoice_id: invoice7.id, status: "shipped") 
      InvoiceItem.create!(item_id: item8.id, invoice_id: invoice8.id, status: "shipped") 
      InvoiceItem.create!(item_id: item9.id, invoice_id: invoice9.id, status: "packaged") 
      InvoiceItem.create!(item_id: item10.id, invoice_id: invoice10.id, status: "packaged") 
      InvoiceItem.create!(item_id: item11.id, invoice_id: invoice11.id, status: "shipped")
    end

    it '#top_five_customers' do
      expect(merchant1.top_five_customers).to eq([customer2, customer3, customer1, customer5, customer4])
      expect(merchant1.top_five_customers).to_not eq([customer6])
    end
  end

  describe "#items_ready_to_ship" do
    it "should have items ready to be shipped" do
      merchant21 = create(:merchant) 
      customer21 = create(:customer) 
      customer22 = create(:customer)
      customer24 = create(:customer)
      customer25 = create(:customer)
      invoice21 = create(:invoice, customer_id: customer21.id, created_at: Time.now - 1.hour) 
      invoice24 = create(:invoice, customer_id: customer22.id, created_at: Time.now - 4.hour)
      invoice29 = create(:invoice, customer_id: customer24.id, created_at: Time.now - 9.hour)
      invoice20 = create(:invoice, customer_id: customer25.id, created_at: Time.now - 10.hour)
      item21 = create(:item, merchant_id: merchant21.id)
      item24 = create(:item, merchant_id: merchant21.id)
      item29 = create(:item, merchant_id: merchant21.id)
      item20 = create(:item, merchant_id: merchant21.id)

      InvoiceItem.create!(item_id: item21.id, invoice_id: invoice21.id, status: "packaged")
      InvoiceItem.create!(item_id: item24.id, invoice_id: invoice24.id, status: "packaged")
      InvoiceItem.create!(item_id: item29.id, invoice_id: invoice29.id, status: "packaged")
      InvoiceItem.create!(item_id: item20.id, invoice_id: invoice20.id, status: "packaged")

      expect(merchant21.items_ready_to_ship).to eq([item20, item29, item24, item21])
    end
  end

  describe "#best revenue day" do
    it "should calculate the day for a merchants highest revenue" do
      customer1 = create(:customer)
      merchant1 = create(:merchant) 
      item1 = create(:item, merchant: merchant1) 
      invoice1 = create(:invoice, customer: customer1, created_at: Time.new('2021'))
      invoice2 = create(:invoice, customer: customer1, created_at: Time.new('2023'))        
      invoice3 = create(:invoice, customer: customer1, created_at: Time.new('2025'))
      invoice_item1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 10, unit_price: 1)
      invoice_item2 = create(:invoice_item, item_id: item1.id, invoice_id: invoice2.id, quantity: 10, unit_price: 5)
      invoice_item3 = create(:invoice_item, item_id: item1.id, invoice_id: invoice3.id, quantity: 10, unit_price: 10)
      transaction1 = create(:transaction, invoice_id: invoice1.id, result: 'success')
      transaction2 = create(:transaction, invoice_id: invoice2.id, result: 'success')
      transaction3 = create(:transaction, invoice_id: invoice3.id, result: 'success')
    
      expect(merchant1.best_revenue_day.created_at).to eq(invoice3.created_at)

      invoice_item4 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 10, unit_price: 100)

      expect(merchant1.best_revenue_day.created_at).to eq(invoice1.created_at)
    end
  end

  describe 'class methods' do
    it "can calculate the top 5 merchants by revenue" do
      customer_1 = create(:customer)
      merchant_1 = create(:merchant)
      invoice_1 = create(:invoice, customer_id: customer_1.id)
      item_1 = create(:item, merchant_id: merchant_1.id)
      invoice_item_1 = create(:invoice_item, item_id: item_1.id, quantity: 10, unit_price: 10, invoice_id: invoice_1.id )
      invoice_item_2 = create(:invoice_item, item_id: item_1.id, quantity: 10, unit_price: 10, invoice_id: invoice_1.id ) 
      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: 'success')
      transaction_6 = create(:transaction, invoice_id: invoice_1.id, result: 'failure')

      customer_2 = create(:customer)
      merchant_2 = create(:merchant)
      invoice_2 = create(:invoice, customer_id: customer_2.id)
      item_2 = create(:item, merchant_id: merchant_2.id)
      invoice_item_3 = create(:invoice_item, item_id: item_2.id, quantity: 10, unit_price: 9, invoice_id: invoice_2.id )
      invoice_item_4 = create(:invoice_item, item_id: item_2.id, quantity: 10, unit_price: 9, invoice_id: invoice_2.id ) 
      transaction_2 = create(:transaction, invoice_id: invoice_2.id, result: 'success')

      customer_3 = create(:customer)
      merchant_3 = create(:merchant)
      invoice_3 = create(:invoice, customer_id: customer_3.id)
      item_3 = create(:item, merchant_id: merchant_3.id)
      invoice_item_4 = create(:invoice_item, item_id: item_3.id, quantity: 10, unit_price: 8, invoice_id: invoice_3.id )
      invoice_item_5 = create(:invoice_item, item_id: item_3.id, quantity: 10, unit_price: 8, invoice_id: invoice_3.id ) 
      transaction_3 = create(:transaction, invoice_id: invoice_3.id, result: 'success')

      customer_4 = create(:customer)
      merchant_4 = create(:merchant)
      invoice_4 = create(:invoice, customer_id: customer_4.id)
      item_4 = create(:item, merchant_id: merchant_4.id)
      invoice_item_5 = create(:invoice_item, item_id: item_4.id, quantity: 10, unit_price: 7, invoice_id: invoice_4.id )
      invoice_item_6 = create(:invoice_item, item_id: item_4.id, quantity: 10, unit_price: 7, invoice_id: invoice_4.id ) 
      transaction_4 = create(:transaction, invoice_id: invoice_4.id, result: 'success')

      customer_5 = create(:customer)
      merchant_5 = create(:merchant)
      invoice_5 = create(:invoice, customer_id: customer_5.id)
      item_5 = create(:item, merchant_id: merchant_5.id)
      invoice_item_6 = create(:invoice_item, item_id: item_5.id, quantity: 10, unit_price: 6, invoice_id: invoice_5.id )
      invoice_item_7 = create(:invoice_item, item_id: item_5.id, quantity: 10, unit_price: 6, invoice_id: invoice_5.id ) 
      transaction_5 = create(:transaction, invoice_id: invoice_5.id, result: 'success')

      customer_6 = create(:customer)
      merchant_6 = create(:merchant)
      invoice_6 = create(:invoice, customer_id: customer_6.id)
      item_6 = create(:item, merchant_id: merchant_6.id)
      invoice_item_7 = create(:invoice_item, item_id: item_6.id, quantity: 10, unit_price: 20, invoice_id: invoice_6.id )
      invoice_item_8 = create(:invoice_item, item_id: item_6.id, quantity: 10, unit_price: 20, invoice_id: invoice_6.id ) 
      transaction_6 = create(:transaction, invoice_id: invoice_6.id, result: 'failure')

      expect(Merchant.top_5_by_revenue).to eq([merchant_1, merchant_2, merchant_3, merchant_4, merchant_5])
      expect(Merchant.top_5_by_revenue).to_not eq([merchant_1, merchant_2, merchant_3, merchant_4, merchant_5, merchant_6])
      expect(Merchant.top_5_by_revenue).to_not eq([merchant_2, merchant_3, merchant_1, merchant_4, merchant_5])
    end
  end
end