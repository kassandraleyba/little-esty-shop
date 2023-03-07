require 'rails_helper'

RSpec.describe "Merchant Invoice Show Page" do
  describe "group project" do
    before do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @customer_1 = create(:customer)
      @customer_2 = create(:customer)
      @item_1 = create(:item, merchant_id: @merchant_1.id)
      @item_2 = create(:item, merchant_id: @merchant_1.id)
      @item_3 = create(:item, merchant_id: @merchant_1.id)
      @item_4 = create(:item, merchant_id: @merchant_2.id)
      @invoice_1 = create(:invoice, customer_id: @customer_1.id, status: 'completed', created_at: "January 28, 2019")
      @invoice_2 = create(:invoice, customer_id: @customer_2.id, status: 'cancelled', created_at: "June 8, 2013")
      @invoice_3 = create(:invoice, customer_id: @customer_2.id, status: 'cancelled', created_at: "May 8, 2013")
      @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, quantity: 10, unit_price: 10, invoice_id: @invoice_1.id, status: 0)
      @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, quantity: 10, unit_price: 8, invoice_id: @invoice_1.id, status: 0 )
      @invoice_item_3 = create(:invoice_item, item_id: @item_4.id, quantity: 8, unit_price: 6, invoice_id: @invoice_3.id )
      
      visit "/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}"
    end
    # 15. Merchant Invoice Show Page
    describe "When I visit my merchant's invoice show page(/merchants/merchant_id/invoices/invoice_id)" do
      it "Then I see information related to that invoice" do
        expect(page).to have_content("ID: #{@invoice_1.id}")
        expect(page).to have_content("Status: #{@invoice_1.status}")
        expect(page).to have_content("Created At: Monday, January 28, 2019")
        expect(page).to have_content("Customer: #{@customer_1.first_name} #{@customer_1.last_name}")

        expect(page).to_not have_content("ID: #{@invoice_2.id}")
        expect(page).to_not have_content("Status: #{@invoice_2.status}")
        expect(page).to_not have_content("Created At: Tuesday, June 8, 2013")
        expect(page).to_not have_content("Customer: #{@customer_2.first_name} #{@customer_2.last_name}")
      end
    end

    # 16. Merchant Invoice Show Page: Invoice Item Information
    describe "When I visit my merchant's invoice show page(/merchants/merchant_id/invoices/invoice_id)" do
      it "Then I see all of my items on the invoice including" do
        expect(page).to have_content("Name: #{@item_1.name}")
        expect(page).to have_content("Unit Price: $#{@invoice_item_1.unit_price}")
        expect(page).to have_content("Status: #{@invoice_item_1.status}")
        expect(page).to have_content("Quantity: #{@invoice_item_1.quantity}")

        expect(page).to_not have_content("Name: #{@item_4.name}")
        expect(page).to_not have_content("Unit Price: $0.06")
        expect(page).to_not have_content("Status: cancelled")
        expect(page).to_not have_content("Quantity: #{@item_4.item_quantity}")
      end
    end

    # 17. Merchant Invoice Show Page: Total Revenue
    describe "When I visit my merchant invoice show page" do
      it "Then I see the total revenue that will be generated from all of my items on the invoice" do
        expect(page).to have_content("Total Revenue: $1.80")

      end

      # 18. Merchant Invoice Show Page: Update Item Status
      it 'field displays current invoice item status and button allows the status to change' do
    
        visit "/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}"
        
        within "#invoice-item-#{@invoice_item_1.id}" do
          select("pending", :from => 'status').click
          click_button('Update Item Status')
    
        
          expect(current_path).to eq("/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}")
          expect(page).to have_content("pending")

          select("shipped", :from => 'status').click
          click_button('Update Item Status')
          
          expect(current_path).to eq("/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}")
          expect(page).to have_content("shipped")
        end
      end
    end
  end

  describe "bulk_discounts" do
   
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
    
    # 6: Merchant Invoice Show Page: Total Revenue and Discounted Revenue
    describe "Then I see the total revenue for my merchant from this invoice (not including discounts)" do
      it "And I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation" do
        visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"

        expect(page).to have_content("Total Revenue: $149.60")
        # quantity * unit_price = total revenue
        expect(page).to have_content("Total Discounted Revenue: $122.06")
        # quantity * unit_price * discount = total discounted revenue
      end
    end

    # 7: Merchant Invoice Show Page: Link to applied discounts
    describe "When I visit my merchant invoice show page" do
      it "Next to each invoice item I see a link to the show page for the bulk discount that was applied (if any)" do
        visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"
        # save_and_open_page
        within "#link-#{@ii_1.id}" do
          expect(page).to have_link("Discount Applied")
          click_on "Discount Applied"
          expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@bulkdiscount1.id}")
        end
      end
    end
  end
end
