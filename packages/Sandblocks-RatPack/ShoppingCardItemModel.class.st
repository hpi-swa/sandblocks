Class {
	#name : #ShoppingCardItemModel,
	#superclass : #RPModel,
	#category : #'Sandblocks-RatPack-Examples'
}

{ #category : #accesing }
ShoppingCardItemModel class >> dataTypes [

	^ Dictionary newFrom: {
		'itemName' -> 'VARCHAR(40)'.
		'priceWithoutTaxes' -> 'DOUBLE'.
	}
]

{ #category : #accesing }
ShoppingCardItemModel class >> defaultValues [

	^ Dictionary newFrom: {
		'itemName' -> 'Squeak Balloon'.
		'priceWithoutTaxes' -> 75.0.
	}
]

{ #category : #accesing }
ShoppingCardItemModel class >> refClass [

	^ ShoppingCardItem
]

{ #category : #accesing }
ShoppingCardItemModel class >> tableName [
	
	^ self refClass name asSymbol
]
