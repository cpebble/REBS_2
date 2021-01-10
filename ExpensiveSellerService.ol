from SellerShipperServiceInterfaceModule import SellerInterface, ShipperInterface
from BuyerServiceInterfaceModule import BuyerShipperInterface, BuyerSellerInterface

include "console.iol"


service SellerService {
    execution { concurrent } // Seller should be able to handle multiple buyers

    inputPort Seller { 
        Location: "socket://localhost:8000"
        Protocol: http { format = "json"}
        Interfaces: SellerInterface
    }
    outputPort Shipper {
        Location: "socket://localhost:8003"
        Protocol: http { format = "json"}
        Interfaces: ShipperInterface
    }
    outputPort SellerBuyer {
         location: "socket://localhost:8002"
         protocol: http { format = "json" }
         interfaces: BuyerSellerInterface
    }

    init {
        sellprice = 9
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