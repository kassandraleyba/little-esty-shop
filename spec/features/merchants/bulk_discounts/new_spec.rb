require 'rails_helper'

RSpec.describe "Merchant Bulk Discount New Page" do
  
  # 2: Merchant Bulk Discount Create
  describe "When I visit /merchants/:merchant_id/bulk_discounts/new" do
    before do
      @merchant1 = Merchant.create!(name: "Sally's", status: 0)
      @merchant2 = Merchant.create!(name: "Bobby's", status: 1)
      @bulk_discount1 = BulkDiscount.create!(name: "20% off 10", percentage_discount: 0.20, quantity_threshold: 10, merchant_id: @merchant1.id)
      @bulk_discount2 = BulkDiscount.create!(name: "30% off 15", percentage_discount: 0.30, quantity_threshold: 15, merchant_id: @merchant1.id)
      @bulk_discount3 = BulkDiscount.create!(name: "15% off 25", percentage_discount: 0.15, quantity_threshold: 25, merchant_id: @merchant2.id)
      
      visit "/merchants/#{@merchant1.id}/bulk_discounts/new"
    end

    it "I am taken to a new page where I see a form to add a new bulk discount" do
      expect(page).to have_content("Create a New Bulk Discount")
      expect(page).to have_field(:name)
      expect(page).to have_field(:percentage_discount)
      expect(page).to have_field(:quantity_threshold)
      expect(page).to have_button("Submit")
    end

    it "When I fill in the form with valid data, Then I am redirected back to the bulk discount index" do
      fill_in "Name", with: "Twelve"
      fill_in "Discount", with: "0.12"
      fill_in "Quantity", with: "5"

      click_on "Submit"

      expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts")
      expect(page).to have_content("Twelve")
    end

    it "When I fill in the form with invalid data, Then the page displays a flash message" do
      fill_in :name, with: "Twelve"
      fill_in :percentage_discount, with: ""
      fill_in :quantity_threshold, with: "5"

      click_button "Submit"

      expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/new")
      expect(page).to have_content("Invalid Input")
    end
  end
end