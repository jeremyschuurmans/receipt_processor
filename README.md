# README

ReceiptProcessor is a Ruby on Rails API that processes receipts and calculates points based on the content of each receipt.

It consists of two endpoints:
1. `POST /receipts/process` - takes receipt data in JSON format, and returns the `receipt_id`
2. `GET /receipts/:id/points` - returns the points awarded for the receipt associated with the `receipt_id`

## Installation Instructions (using Docker)

1. Clone this repository to your local machine
2. `cd` into the appropriate directory
3. run `docker compose up` to build the app within a Docker environment
4. The server will now be running on port 3000
5. You can now send requests to `POST /receipts/process` using the URL `http://localhost:3000/receipts/process`,
and to `GET /receipts/:id/points` using the URL `http://localhost:3000/receipts/:id/points`

## Testing Instructions

1. The easiest way to test this API is probably using `cURL`
2. Open a new terminal
3. To test the `POST /receipts/process` endpoint, run a command similar to the following:
```
curl -X POST -d '{
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
}' -H "Content-Type: application/json" http://localhost:3000/receipts/process
```
It will then return a response similar to: `{"id":"7aa0a3c2-dcbb-4f62-981e-d8f01619d479"}`

4. To test the `GET /receipts/:id/points` endpoint, use the ID returned by the previous request like so:

`curl -X GET http://localhost:3000/receipts/7aa0a3c2-dcbb-4f62-981e-d8f01619d479/points`

It will return a response similar to: `{"points":28}`

## Automated Testing

This API has a full test suite. To run it, from the project directory, run `docker compose run -e "RAILS_ENV=test" web bundle exec rspec`
