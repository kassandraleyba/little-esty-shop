class Admin::DashboardController < ApplicationController

  def index
    @top_5 = Customer.top_5_by_transactions
  end
  
end