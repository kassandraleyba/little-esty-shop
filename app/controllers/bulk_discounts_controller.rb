class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = merchant.bulk_discounts.new(bulk_discount_params)
    if bulk_discount.valid?
      bulk_discount.save
      redirect_to "/merchants/#{merchant.id}/bulk_discounts"
    else
      flash[:notice] = "Invalid Input"
      redirect_to "/merchants/#{merchant.id}/bulk_discounts/new"
    end
  end

  private
  def bulk_discount_params
    params.permit(:name, :percentage_discount, :quantity_threshol, :merchant_id)
  end
end