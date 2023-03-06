# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationship' do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe '.incomplete' do
    before do
      @customer = create(:customer)
      @invoice1 = create(:invoice, customer_id: @customer.id)
      @invoice2 = create(:invoice, customer_id: @customer.id, created_at: Time.new(1999))
      @invoice3 = create(:invoice, customer_id: @customer.id)
      @invoice4 = create(:invoice, customer_id: @customer.id, created_at: Time.new(2022))
      @invoice5 = create(:invoice, customer_id: @customer.id, created_at: Time.new(2002))
      @merchant = create(:merchant)
      @item = create(:item, merchant_id: @merchant.id)
      # StatusKey: 0 => packaged, 1 => pending, 2 => shipped
      @invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item.id, status: 2)
      @invoice_item2 = create(:invoice_item, invoice_id: @invoice2.id, item_id: @item.id, status: 0)
      @invoice_item3 = create(:invoice_item, invoice_id: @invoice3.id, item_id: @item.id, status: 2)
      @invoice_item4 = create(:invoice_item, invoice_id: @invoice4.id, item_id: @item.id, status: 0)
      @invoice_item5 = create(:invoice_item, invoice_id: @invoice5.id, item_id: @item.id, status: 1)
    end

    it 'returns an array of incomplete invoices' do
      expect(Invoice.incomplete).to contain_exactly(@invoice2, @invoice4, @invoice5)
    end

    it 'is ordered by date created at' do
      expect(Invoice.incomplete).to eq([@invoice2, @invoice5, @invoice4])
    end

    it 'lists its items with their relational invoice atrributes' do
      expect(@invoice1.items_with_invoice_attributes.first.name).to eq(@item.name)
      expect(@invoice1.items_with_invoice_attributes.first.quantity).to eq(@invoice_item1.quantity)
      expect(@invoice1.items_with_invoice_attributes.first.unit_price).to eq(@invoice_item1.unit_price)
      expect(@invoice1.items_with_invoice_attributes.first.status).to eq(@invoice_item1.status)
    end

    it 'lists total revenue for an invoice' do
      merchant10 = create(:merchant)
      item10 = create(:item, merchant_id: merchant10.id)
      customer10 = create(:customer)
      invoice10 = create(:invoice, customer_id: customer10.id)
      invoice_item1 = create(:invoice_item, invoice_id: invoice10.id, item_id: item10.id, quantity: 10, unit_price: 2)
      invoice_item2 = create(:invoice_item, invoice_id: invoice10.id, item_id: item10.id, quantity: 10, unit_price: 5)
      
      expect(invoice10.calc_total_revenue).to eq(70)

      invoice_item3 = create(:invoice_item, invoice_id: invoice10.id, item_id: item10.id, quantity: 10, unit_price: 3)

      expect(invoice10.calc_total_revenue).to eq(100)
    end
  end

  describe "instance method - bulk discounts" do
    before do
      @merchant1 = Merchant.create!(name: "Carlos Jenkins") 
      @customer1 = Customer.create!(first_name: "Laura", last_name: "Fiel")
      @customer2 = Customer.create!(first_name: "Bob", last_name: "Fiel")
      
      @invoice1 = @customer1.invoices.create!(status: 1, created_at: "2023-02-27 09:54:09")
      @invoice2 = @customer1.invoices.create!(status: 1, created_at: "2023-02-27 09:54:09")
      
      @bowl = @merchant1.items.create!(name: "bowl", description: "it's a bowl", unit_price: 350) 
      @knife = @merchant1.items.create!(name: "knife", description: "it's a knife", unit_price: 250) 
      @plate = @merchant1.items.create!(name: "plate", description: "it's a plate", unit_price: 250) 
      
      @transaction1 = @invoice1.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
      @transaction2 = @invoice2.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
      
      InvoiceItem.create!(item_id: @bowl.id, invoice_id: @invoice1.id, quantity: 11, unit_price: 270, status: 1)
      InvoiceItem.create!(item_id: @knife.id, invoice_id: @invoice1.id, quantity: 16, unit_price: 540, status: 1)
      InvoiceItem.create!(item_id: @plate.id, invoice_id: @invoice1.id, quantity: 5, unit_price: 670, status: 1)

      InvoiceItem.create!(item_id: @bowl.id, invoice_id: @invoice2.id, quantity: 20, unit_price: 350, status: 1)
      InvoiceItem.create!(item_id: @knife.id, invoice_id: @invoice2.id, quantity: 10, unit_price: 300, status: 1)

      @bulkdiscount1 = @merchant1.bulk_discounts.create!(percentage_discount: 0.20, quantity_threshold: 10)
      @bulkdiscount2 = @merchant1.bulk_discounts.create!(percentage_discount: 0.25, quantity_threshold: 15)
    end

    it "total invoice discount" do
      expect(@invoice1.total_invoice_discount).to eq(2754.0)
    end

    it "total discounted revenue" do
      expect(@invoice1.total_discounted_revenue).to eq(12206.0)
    end
  end
end
