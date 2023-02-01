class Receipt
    attr_reader :retailer, :purchase_date, :purchase_time, :items, :total
    attr_accessor :id

    def initialize(retailer, purchase_date, purchase_time, items, total)
        @retailer = retailer
        @purchase_date = purchase_date
        @purchase_time = purchase_time
        @items = items
        @total = total
    end
end