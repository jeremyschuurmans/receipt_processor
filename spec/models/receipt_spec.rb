require "rails_helper"

describe Receipt do
  let(:receipt) {
    Receipt.new(
      "Target",
      "2022-01-01",
      "13:01",
      [
        {
          "shortDescription": "Sandwich",
          "price": "5.98"
        }
      ],
      "5.98"
    )
  }

  let(:another_receipt) {
    Receipt.new(
      "Costco",
      "2022-01-02",
      "10:34",
      [
        {
          "shortDescription": "Chicken Bake",
          "price": "3.50"
        }
      ],
      "3.50"
    )    
  }

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
    expect(receipt.items.size).to eq(1)
    expect(receipt.items.first[:shortDescription]).to eq("Sandwich")
    expect(receipt.items.first[:price]).to eq("5.98")
  end

  it "has a total" do
    expect(receipt.total).to eq("5.98")
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