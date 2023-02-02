require "rails_helper"

describe Receipt do
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

  let(:receipt) { Receipt.new(JSON_SAMPLE_ONE) }

  let(:another_receipt) { Receipt.new(JSON_SAMPLE_TWO) }

  UUID_REGEX = /^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$/

  it "has an id" do
    expect(receipt.id).not_to be_nil
  end

  it "has a retailer" do
    expect(receipt.retailer).to eq("Target")
  end

  it "has a purchase_date" do
    expect(receipt.purchase_date).to eq("2022-01-01")
  end

  it "has a purchase_time" do
    expect(receipt.purchase_time).to eq("13:01")
  end

  it "has items" do
    expect(receipt.items.size).to eq(5)
    expect(receipt.items.first[:shortDescription]).to eq("Mountain Dew 12PK")
    expect(receipt.items.first[:price]).to eq("6.49")
  end

  it "has a total" do
    expect(receipt.total).to eq("35.35")
  end

  it "has points and defaults to 0" do
    expect(receipt.points).to eq(0)
  end

  describe "#generate_uuid" do
    it "generates a uuid" do
      expect(receipt.generate_uuid).to match(UUID_REGEX)
    end
  end

  describe "#save" do
    it "saves the receipt to a @@receipts class variable" do
      receipt.save

      expect(Receipt.class_variable_get(:@@receipts).first).to eq(receipt)
    end

    it "saves multiple receipts to @@receipts class variable" do
      another_receipt.save

      expect(Receipt.class_variable_get(:@@receipts).count).to eq(2)
    end
  end

  describe ".find_by_id" do
    it "selects the receipt that matches the id passed in" do
      receipt.save
      another_receipt.save

      expect(Receipt.find_by_id(receipt.id).first).to eq(receipt)
    end
  end
end