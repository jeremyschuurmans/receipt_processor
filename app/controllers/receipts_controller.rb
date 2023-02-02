require "./lib/point_calculator"

class ReceiptsController < ApplicationController
  def create
    begin
      receipt = Receipt.new(params["retailer"], params["purchaseDate"], params["purchaseTime"], params["items"], params["total"])
      receipt.points = PointCalculator.new(receipt).process_receipt
      receipt.save

      render json: { "id": receipt.id }.to_json
    rescue StandardError => e
      render json: { "status": 400, "errors": "The receipt is invalid" }.to_json
    end
  end

  def points
    begin
      receipt = Receipt.find_by_id(params[:id]).first

      render json: { "points": receipt.points }.to_json
    rescue StandardError => e
      render json: { "status": 404, "errors": "No receipt found for that id" }.to_json
    end
  end
end
