class Invoice < ApplicationRecord
  enum status: [ :in_progress, :completed, :cancelled ]
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
end
