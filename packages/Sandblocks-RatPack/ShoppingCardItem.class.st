Class {
	#name : #ShoppingCardItem,
	#superclass : #Object,
	#instVars : [
		'itemName',
		'priceWithoutTaxes'
	],
	#category : #'Sandblocks-RatPack-Examples'
}

{ #category : #accessing }
ShoppingCardItem >> itemName [
	^ itemName
]

{ #category : #accessing }
ShoppingCardItem >> itemName: aString [
	itemName := aString
]

{ #category : #accessing }
ShoppingCardItem >> priceWithTaxes [
	^ self priceWithoutTaxes * (1 + WebshopApp taxMultiplier)
]

{ #category : #accessing }
ShoppingCardItem >> priceWithoutTaxes [
	^ priceWithoutTaxes
]

{ #category : #accessing }
ShoppingCardItem >> priceWithoutTaxes: aNumber [
	priceWithoutTaxes := aNumber
]
