require 'securerandom'

class Receipt
  attr_reader :retailer, :purchase_date, :purchase_time, :items, :total
  attr_accessor :id

  @@receipts = []

  def initialize(retailer, purchase_date, purchase_time, items, total)
    @id = generate_uuid
    @retailer = retailer
    @purchase_date = purchase_date
    @purchase_time = purchase_time
    @items = items
    @total = total
  end

  def generate_uuid
    SecureRandom.uuid
  end

  def save
    @@receipts << self
  end

  def self.find_by_id(id)
    @@receipts.select { |receipt| receipt.id == id }
  end
end