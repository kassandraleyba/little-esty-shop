class Admin::InvoicesController < ApplicationController

  def show
    @invoice = Invoice.find(params[:id])
    @invoice_items_and_attributes = @invoice.items_with_invoice_attributes
    @total_revenue = @invoice.calc_total_revenue
    @statuses = ["cancelled", "in_progress", "completed"]
    @total_discounted_revenue = @invoice.total_discounted_revenue
  end

  def index
    @invoices = Invoice.all
  end

  def update
    invoice = Invoice.find(params[:id])
    invoice.update(invoice_params)
    redirect_to 
  end

  private
  def invoice_params
    params.permit(:status)
  end
end