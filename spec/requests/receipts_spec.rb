require 'rails_helper'

RSpec.describe "Receipts", type: :request do
  describe "POST /receipts/process" do
    params = {
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

    it "returns a 200 response" do
      post "/receipts/process", params: params

      expect(response.status).to eq(200)
    end

    it "calulates the points earned by the receipt" do
      post "/receipts/process", params: params
      response_body = JSON.parse(response.body)

      expect(Receipt.find_by_id(response_body["id"]).first.points).to eq(28)
    end

    it "saves the receipt in memory" do
      post "/receipts/process", params: params
      response_body = JSON.parse(response.body)

      expect(Receipt.find_by_id(response_body["id"]).first).to be_an_instance_of(Receipt)
    end

    it "returns the receipt id as json" do
      post "/receipts/process", params: params
      response_body = JSON.parse(response.body)

      expect(response_body).to eq({"id"=>"#{response_body["id"]}"})
    end
  end

  describe "GET /receipts/:id/points" do
    params = {
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

    let(:receipt) { Receipt.new(params) }

    before do
      receipt.points = PointCalculator.new(receipt).process_receipt
      receipt.save
    end

    it "returns a 200 response" do
      get "/receipts/#{receipt.id}/points"

      expect(response.status).to eq(200)
    end

    it "returns the number of points earned by the receipt" do
      get "/receipts/#{receipt.id}/points"
      response_body = JSON.parse(response.body)

      expect(response_body).to eq({"points" => 28})
    end
  end
end
