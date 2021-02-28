Class {
	#name : #WebshopApp,
	#superclass : #SBRPApplication,
	#category : #'Sandblocks-RatPack-Examples'
}

{ #category : #accessing }
WebshopApp class >> freeShippingLimit [

	^ 120
]

{ #category : #accessing }
WebshopApp class >> shippingCost [

	^ 20
]

{ #category : #accessing }
WebshopApp class >> taxMultiplier [

	^ 0.16
]

{ #category : #utils }
WebshopApp >> calculateShippingCostTo: address for: itemPriceWithTaxes [

	^ (itemPriceWithTaxes < self class freeShippingLimit)
		ifTrue: [self findRouteToAddress: address.
			self class shippingCost]
		ifFalse: ["free shipping" 0.0].
]

{ #category : #utils }
WebshopApp >> calculateTaxes: itemPriceWithoutTaxes [

	^ itemPriceWithoutTaxes * self class taxMultiplier
]

{ #category : #utils }
WebshopApp >> findRouteToAddress: address [

	"simulate API call"
	(Delay forMilliseconds: 1000) wait.
]

{ #category : #routing }
WebshopApp >> getShoppingCart [
	"returns total price of all items in card combined"
	<get: '/shopping-cart/'>

	| responseDict shoppingCardItems |
	responseDict := Dictionary new.

	shoppingCardItems := self database loadShoppingCardItemsOf: self sessionUserName.

	responseDict
		at: 'user'
		put: (self sessionUserName).
	responseDict
		at: 'items'
		put: (shoppingCardItems collect: [:item | item objectAsDict]).
	
	responseDict
		at: 'totalPriceWithoutTaxes'
		put: (self priceSumWithoutTaxes: shoppingCardItems).
	responseDict
		at: 'taxes'
		put: (self calculateTaxes: (responseDict at: 'totalPriceWithoutTaxes')).
	responseDict
		at: 'shippingCost'
		put: (self
			calculateShippingCostTo: self sessionUserAddress
			for: ((responseDict at: 'totalPriceWithoutTaxes') + (responseDict at: 'taxes'))).
	responseDict
		at: 'totalPrice'
		put: ((responseDict at: 'totalPriceWithoutTaxes') + (responseDict at: 'taxes') + (responseDict at: 'shippingCost')).

	self sendJson: responseDict asJsonString.
]

{ #category : #'initialize-release' }
WebshopApp >> initialize [ 

	super initialize.
	self database: WebshopDatabase new.
	self
		registerModel: ShoppingCardItemModel.
]

{ #category : #'initialize-release' }
WebshopApp >> initializeSettings [
	self settings globalMiddleware: {
		"#RequestDebugMiddleware."
		"#AuthenticationMiddleware" } asOrderedCollection.
]

{ #category : #utils }
WebshopApp >> priceSumWithoutTaxes: anItemModelList [

	^ anItemModelList
		detectSum: [:model | model object priceWithTaxes]
]

{ #category : #accessing }
WebshopApp >> sessionUserAddress [

	^ 'John Doe'
]

{ #category : #accessing }
WebshopApp >> sessionUserName [

	^ 'John Doe'
]
