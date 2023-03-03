class MerchantsController < ApplicationController
  def dashboard
    @merchant = Merchant.find(params[:merchant_id])
  end

  # def show
  #   # require 'pry'; binding.pry
  #   @merchant = Merchant.find(params[:merchant_id])
  #   @bulk_discounts = @merchant.bulk_discounts
  # end
end