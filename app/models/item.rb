class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :bulk_discounts, through: :merchant
  
  validates :name, :description, :status, presence: true
  validates_numericality_of :unit_price, :merchant_id
  
  enum status: { disabled: 0, enabled: 1 }

  def item_invoice_id
    invoice_items.first.invoice_id
  end

  # def item_invoice_status
  #   invoice_items.first.status
  # end

  # def invoice_where(invoice_id)
  #   invoice_items.where("invoice_id = #{invoice_id}").first
  # end

  def self.enabled
    where(status: "enabled")
  end

  def self.disabled
    where(status: "disabled")
  end

  def self.top_5_by_revenue
    joins(:transactions)
   .where("transactions.result = 'success' AND invoices.status = 1")
   .group("items.id")
   .select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
   .order("revenue desc")
   .limit(5)
  end

  def top_item_day
    Item.joins(:invoices)
    .where(id: self.id, invoices: {status: 1})
    .select("invoices.created_at AS invoice_date, sum(invoice_items.quantity * invoice_items.unit_price) AS sales")
    .group("invoice_date")
    .order("sales desc")
    .limit(1)
    .first
  end

  def item_quantity
    invoice_items.first.quantity
  end
end