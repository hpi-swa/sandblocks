Class {
	#name : #WebshopDatabase,
	#superclass : #RPImageDatabase,
	#category : #'Sandblocks-RatPack-Examples'
}

{ #category : #'as yet unclassified' }
WebshopDatabase >> loadShoppingCardItemsOf: username [

	"simulate database call"
	(Delay forMilliseconds: 100) wait.
	^ self loadModelObjectsOf: ShoppingCardItemModel
]
