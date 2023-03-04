class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
    get_next_three_holidays = HolidayService.get_upcoming_us_holidays.first(3)
    @holidays = get_next_three_holidays.map do |holiday|
      UsHoliday.new(holiday)
    end
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
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

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def update 
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = merchant.bulk_discounts.find(params[:id])
    if bulk_discount.update(bulk_discount_params)
      redirect_to "/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount.id}"
    else
      flash[:notice] = "Invalid Input"
      redirect_to "/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount.id}/edit"
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    bulk_discounts = merchant.bulk_discounts.find(params[:id]).destroy
    redirect_to "/merchants/#{merchant.id}/bulk_discounts"
  end

  private
  def bulk_discount_params
    params.permit(:name, :percentage_discount, :quantity_threshol, :merchant_id)
  end
end