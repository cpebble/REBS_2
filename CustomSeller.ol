from SellerShipperServiceInterfaceModule import SellerInterface, ShipperInterface
from BuyerServiceInterfaceModule import BuyerShipperInterface, BuyerSellerInterface

include "console.iol"


service Seller1 {
    execution { concurrent } // Seller should be able to handle multiple buyers

    inputPort Seller { 
        Location: "auto:json:location:file:start.json"
        Protocol: http { format = "json"}
        Interfaces: SellerInterface
    }
    outputPort Shipper {
        Location: "socket://localhost:8002"
        Protocol: http { format = "json"}
        Interfaces: ShipperInterface
    }
    outputPort SellerBuyer {
         location: "socket://localhost:8000"
         protocol: http { format = "json" }
         interfaces: BuyerSellerInterface
    }

    init {
        if (#args != 1) {
            println@Console("Use selling price as first parameter")()
            throw( Error )
        }
        sellprice = int ( args[0] ) // Cast to int
        println@Console("Opened up shop selling chips for " + sellprice)()
    }

    main {
        [ask(req)] {
            println@Console("A price request was made for: " + req)()
            quote@SellerBuyer(sellprice) 
        }
        [accept(req)] {
            println@Console("Accepted with message: " + req)()
            order@Shipper("One order of chips for " + sellprice + "Dollerydoos")

        }
        [reject(req)] {
            println@Console("Rejected with message: " + req)()
        }
    }

}