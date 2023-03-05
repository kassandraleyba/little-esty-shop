require 'rails_helper'

RSpec.describe "Merchant Invoice Show Page" do

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
      expect(page).to have_content("Unit Price: $0.10")
      expect(page).to have_content("Status: completed")
      expect(page).to have_content("Quantity: #{@item_1.item_quantity}")

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
      
      within "#invoice-item-#{@item_1.id}" do
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

  # 6: Merchant Invoice Show Page: Total Revenue and Discounted Revenue
  describe "Then I see the total revenue for my merchant from this invoice (not including discounts)" do
    it "And I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation" do
      expect(page).to have_content("Total Revenue: ")
      expect(page).to have_content("Total Discounted Revenue: ")
    end
  end
end
