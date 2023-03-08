require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:items).through(:merchant) }
  end

  describe 'validations' do
    it { should validate_numericality_of :percentage_discount }
    it { should validate_numericality_of :quantity_threshold }
  end
end