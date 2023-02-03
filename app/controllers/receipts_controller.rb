require "./lib/point_calculator"

class ReceiptsController < ApplicationController
  def create
    begin
      receipt = Receipt.new(params)
      receipt.points = PointCalculator.new(receipt).process_receipt
      receipt.save

      render json: { "id": receipt.id }
    rescue StandardError
      render json: { "status": 400, "errors": "The receipt is invalid" }, status: 400
    end
  end

  def points
    begin
      receipt = Receipt.find_by_id(params[:id]).first

      render json: { "points": receipt.points }
    rescue StandardError
      render json: { "status": 404, "errors": "No receipt found for that id" }, status: 404
    end
  end
end
