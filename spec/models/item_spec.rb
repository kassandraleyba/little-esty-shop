require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_numericality_of :unit_price }
    it { should validate_presence_of :status }
    it { should validate_numericality_of :merchant_id }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:bulk_discounts).through(:merchant) }
  end

  let!(:merchant1) { create(:merchant) }
  let!(:customer1) { create(:customer) }
  let!(:item1) { create(:item, merchant_id: merchant1.id, status: "enabled")}
  let!(:item2) { create(:item, merchant_id: merchant1.id, status: "disabled")}
  let!(:item3) { create(:item, merchant_id: merchant1.id, status: "enabled")}
  let!(:item4) { create(:item, merchant_id: merchant1.id, status: "disabled")}
  let!(:invoice1) { create(:invoice, customer_id: customer1.id) }

  before do
    InvoiceItem.create!(item_id: item1.id, invoice_id: invoice1.id, status: "packaged")
  end

  describe "instance methods" do
    it "#item_invoice_id" do
      expect(item1.item_invoice_id).to eq(invoice1.id)
    end

    it "#item_invoice_id" do
      expect(item1.item_invoice_id).to eq(invoice1.id)
    end

    it "#top_item_day" do
      merchant1 = create(:merchant)
      customer_1 = create(:customer)
      item_1 = create(:item, merchant_id: merchant1.id)
      invoice_1 = create(:invoice, customer_id: customer_1.id, status: 'completed', created_at: "January 28, 2019")
      invoice_2 = create(:invoice, customer_id: customer_1.id, status: 'completed', created_at: "March 27, 2019")
      invoice_3 = create(:invoice, customer_id: customer_1.id, status: 'completed', created_at: "April 20, 2019")
      invoice_4 = create(:invoice, customer_id: customer_1.id, status: 'completed', created_at: "June 03, 2019")
      invoice_5 = create(:invoice, customer_id: customer_1.id, status: 'completed', created_at: "October 20, 2019")
      invoice_6 = create(:invoice, customer_id: customer_1.id, status: 'completed', created_at: "February 10, 2019")
      invoice_item_1 = create(:invoice_item, item_id: item_1.id, quantity: 10, unit_price: 10, invoice_id: invoice_1.id)
      invoice_item_2 = create(:invoice_item, item_id: item_1.id, quantity: 10, unit_price: 6, invoice_id: invoice_2.id)
      invoice_item_3 = create(:invoice_item, item_id: item_1.id, quantity: 10, unit_price: 8, invoice_id: invoice_3.id)
      invoice_item_4 = create(:invoice_item, item_id: item_1.id, quantity: 10, unit_price: 4, invoice_id: invoice_4.id)
      invoice_item_5 = create(:invoice_item, item_id: item_1.id, quantity: 10, unit_price: 2, invoice_id: invoice_5.id)
      invoice_item_6 = create(:invoice_item, item_id: item_1.id, quantity: 10, unit_price: 1, invoice_id: invoice_6.id)
    
      expect(item_1.top_item_day.invoice_date).to eq("January 28, 2019")
    end

    it "should return the quantity from the invoice_item" do

      merchant1 = create(:merchant)
      customer_1 = create(:customer)
      item_1 = create(:item, merchant_id: merchant1.id)
      invoice_1 = create(:invoice, customer_id: customer_1.id, status: 'completed', created_at: "January 28, 2019")
      invoice_2 = create(:invoice, customer_id: customer_1.id, status: 'completed', created_at: "March 27, 2019")
      invoice_3 = create(:invoice, customer_id: customer_1.id, status: 'completed', created_at: "April 20, 2019")
      invoice_4 = create(:invoice, customer_id: customer_1.id, status: 'completed', created_at: "June 03, 2019")
      invoice_5 = create(:invoice, customer_id: customer_1.id, status: 'completed', created_at: "October 20, 2019")
      invoice_6 = create(:invoice, customer_id: customer_1.id, status: 'completed', created_at: "February 10, 2019")
      invoice_item_1 = create(:invoice_item, item_id: item_1.id, quantity: 10, unit_price: 10, invoice_id: invoice_1.id)
      invoice_item_2 = create(:invoice_item, item_id: item_1.id, quantity: 10, unit_price: 6, invoice_id: invoice_2.id)
      invoice_item_3 = create(:invoice_item, item_id: item_1.id, quantity: 10, unit_price: 8, invoice_id: invoice_3.id)
      invoice_item_4 = create(:invoice_item, item_id: item_1.id, quantity: 10, unit_price: 4, invoice_id: invoice_4.id)
      invoice_item_5 = create(:invoice_item, item_id: item_1.id, quantity: 10, unit_price: 2, invoice_id: invoice_5.id)
      invoice_item_6 = create(:invoice_item, item_id: item_1.id, quantity: 10, unit_price: 1, invoice_id: invoice_6.id)

      expect(item_1.item_quantity).to eq(10)
    end
  end

  describe ".class methods" do
    it "disabled-buttons" do
      expect(Item.disabled.sort).to eq([item2, item4].sort)
    end

    it "enabled-buttons" do
      expect(Item.enabled.sort).to eq([item1, item3].sort)
    end
  
    it '.top_5_by_revenue' do
      merchant1 = create(:merchant)
      customer_1 = create(:customer)
      item_1 = create(:item, merchant_id: merchant1.id)
      item_2 = create(:item, merchant_id: merchant1.id)
      item_3 = create(:item, merchant_id: merchant1.id)
      item_4 = create(:item, merchant_id: merchant1.id)
      item_5 = create(:item, merchant_id: merchant1.id)
      item_6 = create(:item, merchant_id: merchant1.id)
      invoice_1 = create(:invoice, customer_id: customer_1.id, status: "completed")
      invoice_2 = create(:invoice, customer_id: customer_1.id, status: "completed")
      invoice_3 = create(:invoice, customer_id: customer_1.id, status: "completed")
      invoice_4 = create(:invoice, customer_id: customer_1.id, status: "completed")
      invoice_5 = create(:invoice, customer_id: customer_1.id, status: "completed")
      invoice_6 = create(:invoice, customer_id: customer_1.id, status: "completed")
      invoice_item_1 = create(:invoice_item, item_id: item_1.id, quantity: 10, unit_price: 10, invoice_id: invoice_1.id )
      invoice_item_2 = create(:invoice_item, item_id: item_2.id, quantity: 10, unit_price: 6, invoice_id: invoice_2.id )
      invoice_item_3 = create(:invoice_item, item_id: item_3.id, quantity: 10, unit_price: 8, invoice_id: invoice_3.id )
      invoice_item_4 = create(:invoice_item, item_id: item_4.id, quantity: 10, unit_price: 4, invoice_id: invoice_4.id )
      invoice_item_5 = create(:invoice_item, item_id: item_5.id, quantity: 10, unit_price: 2, invoice_id: invoice_5.id )
      invoice_item_6 = create(:invoice_item, item_id: item_6.id, quantity: 10, unit_price: 1, invoice_id: invoice_6.id )
      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: 'success')
      transaction_2 = create(:transaction, invoice_id: invoice_2.id, result: 'success')
      transaction_3 = create(:transaction, invoice_id: invoice_3.id, result: 'success')
      transaction_4 = create(:transaction, invoice_id: invoice_4.id, result: 'success')
      transaction_5 = create(:transaction, invoice_id: invoice_5.id, result: 'success')
      transaction_6 = create(:transaction, invoice_id: invoice_6.id, result: 'success')

      expect(Item.top_5_by_revenue).to contain_exactly(item_1, item_2, item_3, item_4, item_5)
      expect(Item.top_5_by_revenue).to_not eq([item_1, item_2, item_3, item_4, item_5, item_6])
      expect(Item.top_5_by_revenue).to_not eq([item_6, item_4, item_3, item_2, item_1])
    end
  end
end
