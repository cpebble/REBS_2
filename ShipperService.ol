from SellerShipperServiceInterfaceModule import SellerInterface, ShipperInterface
from BuyerServiceInterfaceModule import BuyerShipperInterface, BuyerSellerInterface

include "console.iol"

service ShipperService {
    execution { concurrent } // Seller should be able to handle multiple buyers

    inputPort Shipper {
        Location: "socket://localhost:8002"
        Protocol: http { format = "json"}
        Interfaces: ShipperInterface
    }
    outputPort ShipperBuyer {
        Location: "socket://localhost:8001"
        Protocol: http { format = "json" }
        Interfaces: BuyerShipperInterface
    }

    init {
        println@Console("Opened up shipper sending chips")()
    }

    main {
        [order(msg)] {
            println@Console("Order recieved")()
            details@ShipperBuyer("One order of Chips.\n
Thanks for shopping REBS Chips emporium(TM)")
        }
    }

}