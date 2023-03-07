require 'rails_helper'

describe 'Admin Invoices show page' do
  describe 'As an admin' do
    describe 'When I visit the admin invoice show page' do
      let!(:customer_2) {create(:customer) }
      let!(:merchant_2) {create(:merchant) }
      let!(:invoice_2) {create(:invoice, customer_id: customer_2.id, status:'completed', created_at: Time.new(2002)) }
      let!(:item_2) {create(:item, merchant_id: merchant_2.id) }
      let!(:invoice_item_3) {create(:invoice_item, item_id: item_2.id, quantity: 10, unit_price: 9, invoice_id: invoice_2.id ) }
      let!(:invoice_item_4) {create(:invoice_item, item_id: item_2.id, quantity: 10, unit_price: 9, invoice_id: invoice_2.id ) }
      let!(:transaction_2) {create(:transaction, invoice_id: invoice_2.id, result: 'success') }
  
      it "I see information related to that invoice including: - Invoice id - Invoice status - Invoice created_at date in the format 'Monday, July 18, 2019' - Customer first and last name" do
        visit admin_invoice_path(invoice_2)
  
        expect(page).to have_content("#{invoice_2.id}")
        expect(page).to have_content("#{invoice_2.status}")
        expect(page).to have_content("Tuesday, January 1, 2002")
        expect(page).to have_content("#{invoice_2.customer.first_name}")
        expect(page).to have_content("#{invoice_2.customer.last_name}")
      end

      it "I see all the items on the invoice including: item name, item quantity, price item sold for and invoice item status" do
        visit admin_invoice_path(invoice_2)
        
        within(".items") do
          expect(page).to have_content("#{invoice_2.items.first.name}")
          expect(page).to have_content("#{invoice_item_3.quantity}")
          expect(page).to have_content("#{invoice_item_3.status}")
          expect(page).to have_content("#{invoice_item_3.unit_price}")
        end
      end

      it "I see the total revenue that will be generated from this invoice" do
        visit admin_invoice_path(invoice_2)
        
        expect(page).to have_content("Total Revenue: $1.80")
      end

      it "I see the invoice status is a select field and I see that the invoice's current status is selected when I click this select field. Then I can select a new status for the Invoice, and next to the select field I see a button to 'Update Invoice Status'. When I click this button I am taken back to the admin invoice show page and I see that my Invoice's status has now been updated" do
        visit admin_invoice_path(invoice_2)

        select("in_progress", :from => 'status').click
        click_button('Update Invoice Status')
       
        expect(current_path).to eq(admin_invoice_path(invoice_2))
        expect(page).to have_content("in_progress")

        select("cancelled", :from => 'status').click
        click_button('Update Invoice Status')

        expect(current_path).to eq(admin_invoice_path(invoice_2))
        expect(page).to have_content("cancelled")
      end
    end

    describe "bulk discounts" do
       
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

        visit "/admin/invoices/#{@invoice1.id}"
      end
    
      # 8: Admin Invoice Show Page: Total Revenue and Discounted Revenue
      describe "When I visit an admin invoice show page" do
        describe "Then I see the total revenue from this invoice (not including discounts)" do
          it "And I see the total discounted revenue from this invoice which includes bulk discounts in the calculation" do
            expect(page).to have_content("Total Revenue: $149.60")
            expect(page).to have_content("Total Discounted Revenue: $122.06")
          end
        end
      end
    end
  end
end