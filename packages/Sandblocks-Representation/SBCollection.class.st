Class {
	#name : #SBCollection,
	#superclass : #SBBlock,
	#instVars : [
		'collection'
	],
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBCollection >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBCollection >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		listDirection: #leftToRight;
		attachDecorator: SBMoveDecorator new
]

{ #category : #'as yet unclassified' }
SBCollection >> isTopLevel [

	^ true
]

{ #category : #'as yet unclassified' }
SBCollection >> object [

	^ collection
]

{ #category : #'as yet unclassified' }
SBCollection >> object: aCollection [

	collection := aCollection.
	
	self removeAllMorphs.
	
	aCollection do: [:e |
		e convertedFor: self objectInterfaceForDrop do: [:o | self addMorphBack: o]]
]

{ #category : #'as yet unclassified' }
SBCollection >> objectInterfaceAt: aNumber adding: aBoolean [

	^ SBInterfaces topLevel
]

{ #category : #'as yet unclassified' }
SBCollection >> symbols [

	^ #('{' '}')
]
