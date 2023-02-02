require "rails_helper"
require "point_calculator"

describe "PointCalculator" do
  JSON_SAMPLE_ONE = {
    "retailer": "Target",
    "purchaseDate": "2022-01-01",
    "purchaseTime": "13:01",
    "items": [
      {
        "shortDescription": "Mountain Dew 12PK",
        "price": "6.49"
      },{
        "shortDescription": "Emils Cheese Pizza",
        "price": "12.25"
      },{
        "shortDescription": "Knorr Creamy Chicken",
        "price": "1.26"
      },{
        "shortDescription": "Doritos Nacho Cheese",
        "price": "3.35"
      },{
        "shortDescription": "   Klarbrunn 12-PK 12 FL OZ  ",
        "price": "12.00"
      }
    ],
    "total": "35.35"
  }

  JSON_SAMPLE_TWO = {
    "retailer": "M&M Corner Market",
    "purchaseDate": "2022-03-20",
    "purchaseTime": "14:33",
    "items": [
      {
        "shortDescription": "Gatorade",
        "price": "2.25"
      },{
        "shortDescription": "Gatorade",
        "price": "2.25"
      },{
        "shortDescription": "Gatorade",
        "price": "2.25"
      },{
        "shortDescription": "Gatorade",
        "price": "2.25"
      }
    ],
    "total": "9.00"
  }

  let(:receipt_one) { Receipt.new(JSON_SAMPLE_ONE) }

  let(:receipt_two) { Receipt.new(JSON_SAMPLE_TWO) }

  let(:point_calculator_first_receipt) { PointCalculator.new(receipt_one) }
  let(:point_calculator_second_receipt) { PointCalculator.new(receipt_two) }

  describe "#process_retailer_name" do
    it "calculates one point for every alphanumeric character in the retailer name when there are no spaces or non-alphanumeric characters" do
      expect(point_calculator_first_receipt.process_retailer_name).to eq(6)
    end

    it "calculates one point for every alphanumeric character in the retailer name when there are spaces and/or non-alphanumeric characters" do      
      expect(point_calculator_second_receipt.process_retailer_name).to eq(14)
    end
  end

  describe "#process_round_dollar_amount_total" do
    it "adds fifty points if total amount is a round dollar amount with no cents" do
      expect(point_calculator_second_receipt.process_round_dollar_amount_total).to eq(50)
    end

    it "does not add fifty points if total amount is not a round dollar amount with no cents" do
      expect(point_calculator_first_receipt.process_round_dollar_amount_total).to eq(0)
    end
  end

  describe "#process_multiple_of_total" do
    it "adds twenty-five points if total is a multiple of 0.25" do
      expect(point_calculator_second_receipt.process_multiple_of_total).to eq(25)
    end

    it "does not add twenty-five points if total is not a multiple of 0.25" do
      expect(point_calculator_first_receipt.process_multiple_of_total).to eq(0)
    end
  end

  describe "#process_every_two_items" do
    it "adds five points for every two items on the receipt" do
      expect(point_calculator_first_receipt.process_every_two_items).to eq(10)
    end
  end

  describe "#process_items_length" do
    it "multiplies the price of an item by 0.2 and rounds up if the trimmed length of the item description is a multiple of 3" do
      expect(point_calculator_first_receipt.process_items_length).to eq(6)
    end

    it "does not multiply the price of an item by 0.2 and round up if the trimmed length of the item description is not a multiple of 3" do
      expect(point_calculator_second_receipt.process_items_length).to eq(0)
    end
  end

  describe "#process_purchase_date" do
    it "adds six points if the day in the purchase date is odd" do
      expect(point_calculator_first_receipt.process_purchase_date).to eq(6)
    end

    it "does not add six points if the day in the purchase date is even" do
      expect(point_calculator_second_receipt.process_purchase_date).to eq(0)
    end
  end

  describe "#process_purchase_time" do
    it "adds ten points if the time of purchase is after 2:00pm and before 4:00pm" do
      expect(point_calculator_second_receipt.process_purchase_time).to eq(10)
    end

    it "does not add ten points if the time of purchase is not after 2:00pm and before 4:00pm" do
      expect(point_calculator_first_receipt.process_purchase_time).to eq(0)
    end
  end

  describe "#process_receipt" do
    it "calculates the correct number of points for a given receipt" do
      processed_receipt = point_calculator_first_receipt.process_receipt

      expect(processed_receipt).to eq(28)
    end

    it "calculates the correct number of points for a given receipt" do
      processed_receipt = point_calculator_second_receipt.process_receipt

      expect(processed_receipt).to eq(109)
    end
  end
end
