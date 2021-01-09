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
			if (price <5) {
				println@Console( "price lower than 5")();
				accept@Seller("Ok to buy chips for " + price);
				[details(invoice)]{println@Console( "Received "+invoice+" from Shipper!")()}
			} else {
				println@Console( "price not lower than 5")();
				reject@Seller("Not ok to buy chips for " + price)
			}
		 }
        
     		}
	}
}
