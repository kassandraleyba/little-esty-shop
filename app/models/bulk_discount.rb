class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant

  validates_presence_of :percentage_discount, numericality: { greater_than: 0, less_than_or_equal_to: 1 }
  validates_numericality_of :quantity_threshold, { only_integer: true, greater_than_or_equal_to: 1 }
end