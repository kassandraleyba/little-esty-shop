class MerchantsController < ApplicationController
  def dashboard
    @merchant = Merchant.find(params[:merchant_id])
  end
end