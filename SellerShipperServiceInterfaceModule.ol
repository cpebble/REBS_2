
interface SellerInterface {
    OneWay:
	ask( string ),
    accept( string ),
    reject( string )
}

type OrderRequest: void {
    .item: string
    .location: string
}

interface ShipperInterface {
    OneWay:
        order( string )
}

