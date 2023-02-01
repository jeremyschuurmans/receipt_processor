require "rails_helper"

describe Receipt do
    let(:receipt) { Receipt.new(
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
end