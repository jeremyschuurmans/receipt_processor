require 'rails_helper'

RSpec.describe "Receipts", type: :request do
  let(:params) {
    {
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
  }

  let(:invalid_params) {
    {
      "retailer": "Target",
      "purchaseDate": "2022-01-01",
      "purchaseTime": "13:01",
      "total": "35.35"
    }
  }

  let(:headers) { { "content-type" => "application/json" } }

  describe "POST /receipts/process" do
    it "returns a 200 response" do
      post "/receipts/process", headers: headers, params: params.to_json

      expect(response.status).to eq(200)
    end

    it "calulates the points earned by the receipt" do
      post "/receipts/process", headers: headers, params: params.to_json
      response_body = JSON.parse(response.body)

      expect(Receipt.find_by_id(response_body["id"]).first.points).to eq(28)
    end

    it "saves the receipt in memory" do
      post "/receipts/process", headers: headers, params: params.to_json
      response_body = JSON.parse(response.body)

      expect(Receipt.find_by_id(response_body["id"]).first).to be_an_instance_of(Receipt)
    end

    it "returns the receipt id as json" do
      post "/receipts/process", headers: headers, params: params.to_json
      response_body = JSON.parse(response.body)

      expect(response_body).to eq({"id"=>"#{response_body["id"]}"})
    end

    it "returns an error if an invalid receipt is submitted" do
      post "/receipts/process", headers: headers, params: invalid_params.to_json
      response_body = JSON.parse(response.body)

      expect(response.status).to eq(400)
      expect(response_body).to eq({"id"=>"bad_request", "message"=>"#/components/schemas/Receipt missing required parameters: items"})
    end
  end

  describe "GET /receipts/:id/points" do
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

    it "returns an error if a receipt cannot be found" do
      get "/receipts/1/points"
      response_body = JSON.parse(response.body)
      
      expect(response.status).to eq(404)
      expect(response_body).to eq({"status"=>404, "errors"=>"No receipt found for that id"})
    end
  end
end
