class InvoicesController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
   
  end

  def show
    @invoice = Invoice.find(params[:id])
    @invoice_items = @invoice.items_with_attributes
    @total_revenue = @invoice.calc_total_revenue
    @statuses = ["pending", "packaged", "shipped"]
    @total_discounted_revenue = @invoice.total_discounted_revenue
  end
end
