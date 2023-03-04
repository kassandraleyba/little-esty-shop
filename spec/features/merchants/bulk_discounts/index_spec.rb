require 'rails_helper'

RSpec.describe "Merchant Bulk Discount Index Page" do

  # 2: Merchant Bulk Discount Create
  # When I fill in the form with valid data
  # Then I am redirected back to the bulk discount index
  # And I see my new bulk discount listed

  describe "When I visit /merchants/:merchant_id/bulk_discounts" do
    before do
      @merchant1 = Merchant.create!(name: "Sally's", status: 0)
      @merchant2 = Merchant.create!(name: "Bobby's", status: 1)
      @bulk_discount1 = BulkDiscount.create!(name: "20% off 10", percentage_discount: 0.20, quantity_threshold: 10, merchant_id: @merchant1.id)
      @bulk_discount2 = BulkDiscount.create!(name: "30% off 15", percentage_discount: 0.30, quantity_threshold: 15, merchant_id: @merchant1.id)
      @bulk_discount3 = BulkDiscount.create!(name: "15% off 25", percentage_discount: 0.15, quantity_threshold: 25, merchant_id: @merchant2.id)
      
      visit "/merchants/#{@merchant1.id}/bulk_discounts"
    end

    it "I see a link for a new discount & when I click this link, I am taken to a new page where I see a form to add a new bulk discount" do
      expect(page).to have_link("New Discount")
      click_on "New Discount"
      expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/new")
    end
  end
end
