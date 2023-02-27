class MerchantsController < ApplicationController
  def dashboards
    @merchant = Merchant.find(params[:merchant_id])
  end

  def items
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items
    @top_5_items = @items.top_5_by_revenue
  end
end