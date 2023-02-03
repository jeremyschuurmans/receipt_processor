class PointCalculator
  def initialize(receipt)
    @receipt = receipt
    @points = 0
  end

  def process_receipt
    process_retailer_name
    process_round_dollar_amount_total
    process_multiple_of_total
    process_every_two_items
    process_items_length
    process_purchase_date
    process_purchase_time

    @points
  end

  def process_retailer_name
    # One point for every alphanumeric character in the retailer name
    @points += @receipt.retailer.gsub(/[^0-9a-z]/i, '').length
  end

  def process_round_dollar_amount_total
    # 50 points if the total is a round dollar amount with no cents
    @receipt.total.split(".").last == "00" ? @points += 50 : @points += 0
  end

  def process_multiple_of_total
    # 25 points if the total is a multiple of 0.25
    @receipt.total.to_f % 0.25 == 0 ? @points += 25 : @points += 0
  end

  def process_every_two_items
    # 5 points for every two items on the receipt
    @points += 5 * (@receipt.items.length / 2)
  end

  def process_items_length
    # If the trimmed length of the item description is a multiple of 3, multiply the price by 0.2 and round up to the nearest integer
    # The result is the number of points earned
    @receipt.items.each do |item|
      if item[:shortDescription].strip.length % 3 == 0
          @points += (item[:price].to_f * 0.2).ceil
      end
    end

    @points
  end

  def process_purchase_date
    # 6 points if the day in the purchase date is odd
    @receipt.purchase_date.split("-").last.to_i.odd? ? @points += 6 : @points += 0
  end

  def process_purchase_time
    # 10 points if the time of purchase is after 2:00pm and before 4:00pm
    @receipt.purchase_time.to_datetime > "14:00".to_datetime && @receipt.purchase_time.to_datetime < "16:00".to_datetime ? @points += 10 : @points += 0
  end
end