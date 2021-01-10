from SellerShipperServiceInterfaceModule import SellerInterface
from BuyerServiceInterfaceModule import BuyerShipperInterface, BuyerSellerInterface

include "console.iol"

service BuyerService {


    execution{ single }

    // Communication with sellers
    outputPort Seller {
        location: "socket://localhost:9000"
        protocol: http { format = "json" }
        interfaces: SellerInterface
    }
    outputPort Seller2 {
        location: "socket://localhost:9001"
        protocol: http { format = "json" }
        interfaces: SellerInterface
    }

    // Input channels for seller and shipper
    inputPort ShipperBuyer {
        location: "socket://localhost:8001"
        protocol: http { format = "json" }
        interfaces: BuyerShipperInterface
    }
    inputPort SellerBuyer {
        location: "socket://localhost:8000"
        protocol: http { format = "json" }
        interfaces: BuyerSellerInterface
    }

    init {
        price_target = 10
        println@Console("I want to buy chips. I wonder if i can buy any for " + 
        price_target + "Dollerydoos?")()
    }

    main {
        // Collect two prices from two different sellers
        ask@Seller("chips") 
		{[quote(price)]{
                println@Console("Got price " + price + " from seller 1")()
                price1 = price
            }
     	}
        ask@Seller2("chips")
        {[quote(price)]{
            println@Console("Got price " + price + " from seller 2")()
            price2 = price
        }}
        // Compare the two different prices and either accept or reject the offer
        if ( price1 > price2 && price2 < price_target) {
            println@Console("Seller 2 is less expensive, accepting")()
            accept@Seller2("Ok to buy for price " + price2)
            reject@Seller("We're going in a different direction")
            ordered = true
        } else if ( price1 < price_target) {
            println@Console("Seller 1 is less expensive, accepting")()
            accept@Seller("Ok to buy for price " + price1)
            reject@Seller2("We're going in a different direction")
            ordered = true
        } else {
            println@Console("No chips for me :'( ")()
            reject@Seller("We're going in a different direction")
            reject@Seller2("We're going in a different direction")
            ordered = false
        }
        if (ordered) {
            // Finally wait for shipping information
            [details(invoice)]{println@Console( "Response from shipper:
----
"+invoice+"
----"
            )()}
        }
	}
}
