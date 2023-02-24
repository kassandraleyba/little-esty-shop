class Merchant < ApplicationRecord
  validates :name, presence: true
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def top_five_customers
    customers.joins(:transactions).where(transactions: {result: 'success'})
    .select("customers.*, count(DISTINCT transactions.id) as transaction_count")
    .group("customers.id").order("transaction_count desc").limit(5)
  end
end
