
interface SellerInterface {
    OneWay:
	ask( string ),
        accept( string ),
        reject( string )
}

interface ShipperInterface {
    OneWay:
        order( string )
}

