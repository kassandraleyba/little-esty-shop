require 'rails_helper'

RSpec.describe "Merchant Bulk Discount Show Page" do
  before do
    @merchant1 = Merchant.create!(name: "Sally's", status: 0)
    @merchant2 = Merchant.create!(name: "Bobby's", status: 1)
    @bulk_discount1 = BulkDiscount.create!(name: "20% off 10", percentage_discount: 0.20, quantity_threshold: 10, merchant_id: @merchant1.id)
    @bulk_discount2 = BulkDiscount.create!(name: "30% off 15", percentage_discount: 0.30, quantity_threshold: 15, merchant_id: @merchant1.id)
    @bulk_discount3 = BulkDiscount.create!(name: "15% off 25", percentage_discount: 0.15, quantity_threshold: 25, merchant_id: @merchant2.id)
    
    visit "/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount1.id}"
  end

  # 4: Merchant Bulk Discount Show
  describe "When I visit my bulk discount show page" do
    it "Then I see the bulk discount's quantity threshold and percentage discount" do
      expect(page).to have_content("Quantity: 10")
      expect(page).to have_content("Discount: 0.2%")

      expect(page).to_not have_content("Quantity: 15")
      expect(page).to_not have_content("Discount: 0.3%")
    end
  end

  # 5: Merchant Bulk Discount Edit
  describe "I see a link to edit the bulk discount and When I click this link" do
    it "Then I am taken to a new page with a form to edit the discount" do
      expect(page).to have_content("Edit #{@bulk_discount1.name}")
      click_on "Edit #{@bulk_discount1.name}"
      expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount1.id}/edit")
    end

    it "I see that the current info & when I change & click submit, I am redirected to the show page" do
      visit "/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount1.id}/edit"

      expect(page).to have_content("Edit Bulk Discount")
      expect(page).to have_field(:name, with: "20% off 10")
      expect(page).to have_field(:percentage_discount, with: "0.2")
      expect(page).to have_field(:quantity_threshold, with: 10)
      expect(page).to have_button("Submit")
      click_on "Submit"
      expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount1.id}")
    end
  end
end
