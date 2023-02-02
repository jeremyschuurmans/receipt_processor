require 'securerandom'

class Receipt
  attr_reader :retailer, :purchase_date, :purchase_time, :items, :total
  attr_accessor :id, :points

  @@receipts = []
  # params["retailer"], params["purchaseDate"], params["purchaseTime"], params["items"], params["total"]
  def initialize(params = {})
    @id = generate_uuid
    @retailer = params[:retailer]
    @purchase_date = params[:purchaseDate]
    @purchase_time = params[:purchaseTime]
    @items = params[:items]
    @total = params[:total]
    @points = 0
  end

  # Generates a universally unique identifier for use as the receipt_id  
  def generate_uuid
    SecureRandom.uuid
  end

  # Since we are not using a database, mimicing a save here by adding receipts to an array
  def save
    @@receipts << self
  end

  # Retrieving the receipt from the array by id
  def self.find_by_id(id)
    @@receipts.select { |receipt| receipt.id == id }
  end
end