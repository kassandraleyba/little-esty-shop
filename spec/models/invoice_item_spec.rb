require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_many(:bulk_discounts).through(:item)  }
  end

  describe 'instance method' do
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
      
      @ii_1 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @invoice1.id, quantity: 11, unit_price: 270, status: 1)
      @ii_2 = InvoiceItem.create!(item_id: @knife.id, invoice_id: @invoice1.id, quantity: 16, unit_price: 540, status: 1)
      @ii_3 = InvoiceItem.create!(item_id: @plate.id, invoice_id: @invoice1.id, quantity: 5, unit_price: 670, status: 1)

      @ii_4 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @invoice2.id, quantity: 20, unit_price: 350, status: 1)
      @ii_5 = InvoiceItem.create!(item_id: @knife.id, invoice_id: @invoice2.id, quantity: 10, unit_price: 300, status: 1)

      @bulkdiscount1 = @merchant1.bulk_discounts.create!(percentage_discount: 0.20, quantity_threshold: 10)
      @bulkdiscount2 = @merchant1.bulk_discounts.create!(percentage_discount: 0.25, quantity_threshold: 15)

    end

    it 'returns true when invoice item is past discount threshold' do
      expect(@ii_1.best_discount).to eq(@bulkdiscount1)
      expect(@ii_2.best_discount).to eq(@bulkdiscount2)
      expect(@ii_3.best_discount).to eq(nil)
    end
  end
end
