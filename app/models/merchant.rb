class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices
  has_many :bulk_discounts
  
  validates :name, presence: true

  enum status: [:disabled, :enabled]

  def top_five_customers
    customers.joins(:transactions)
    .where(transactions: {result: 'success'})
    .select("customers.*, count(DISTINCT transactions.id) as transaction_count")
    .group("customers.id")
    .order("transaction_count desc").limit(5)
  end
  
  def self.top_5_by_revenue
   Merchant.joins(:transactions)
   .where("transactions.result = 'success'")
   .group("merchants.id")
   .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
   .order("revenue desc")
   .limit(5)
 end

  # def self.top_5_by_revenue
  #   Merchant.find_by_sql("
  #     SELECT merchants.*,
  #     SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue
  #     FROM merchants
  #     INNER JOIN items ON items.merchant_id = merchants.id
  #     INNER JOIN invoice_items ON invoice_items.item_id = items.id
  #     INNER JOIN invoices ON invoices.id = invoice_items.invoice_id
  #     INNER JOIN transactions ON transactions.invoice_id = invoices.id
  #     WHERE transactions.result = 'success'
  #     GROUP BY merchants.id
  #     ORDER BY revenue desc
  #     LIMIT 5;
  #     ")
  #   end

    def items_ready_to_ship
      # Item.joins(:invoice_items, :invoices)
      # .where("invoice_items.status = ?", 0)
      # .order(created_at: :desc)
      # .pluck("items.name, invoices.created_at").flatten

      Item.joins(:invoices)
      .where("invoice_items.status = ?", 0)
      .order("invoices.created_at asc")
      .select("items.*, invoices.created_at as inv_time")
    end

    def best_revenue_day
      self.invoices.joins(:transactions)
      .where("transactions.result = 'success'")
      .select("invoices.created_at, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
      .group("invoices.created_at")
      .order("revenue desc")
      .order("invoices.created_at asc")
      .limit(1)
      .first
    end
end
