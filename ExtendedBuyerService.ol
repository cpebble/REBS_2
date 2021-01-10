from SellerShipperServiceInterfaceModule import SellerInterface
from BuyerServiceInterfaceModule import BuyerShipperInterface, BuyerSellerInterface

include "console.iol"

service BuyerService {

    execution{ single }

    outputPort Seller {
         location: "socket://localhost:8000"
         protocol: http { format = "json" }
         interfaces: SellerInterface
    }
    outputPort ExpensiveSeller {
         location: "socket://localhost:8000"
         protocol: http { format = "json" }
         interfaces: SellerInterface
    }

    inputPort ShipperBuyer {
         location: "socket://localhost:8001"
         protocol: http { format = "json" }
         interfaces: BuyerShipperInterface
    }
    inputPort SellerBuyer {
         location: "socket://localhost:8002"
         protocol: http { format = "json" }
         interfaces: BuyerSellerInterface
    }
    main {
          ask@Seller("chips") 
		{[quote(price)]{
               println@Console("Got price " + price + " from seller 1")()
               price1 = price
               }
     	}
          ask@ExpensiveSeller("chips")
          {[quote(price)]{
               println@Console("Got price " + price + " from seller 2")()
               price2 = price
          }}
          if ( price1 > price2 && price2 < 10) {
               println@Console("Seller 2 is less expensive, accepting")()
               accept@ExpensiveSeller("Ok to buy for price " + price2)
               reject@Seller("We're going in a different direction")
          } else if ( price1 < 10) {
               println@Console("Seller 1 is less expensive, accepting")()
               accept@Seller("Ok to buy for price " + price1)
               reject@ExpensiveSeller("We're going in a different direction")
          } else {
               println@Console("No chips for me :'( ")()
               reject@Seller("We're going in a different direction")
               reject@ExpensiveSeller("We're going in a different direction")

          }
	}
}
