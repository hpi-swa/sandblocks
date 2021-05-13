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
SBCollection >> interface: anInterfaceCollection object: aCollection [

	collection := aCollection.
	
	self removeAllMorphs.
	
	aCollection do: [:e |
		e
			convertedFor: (self objectInterfaceNear: nil at: #after), (anInterfaceCollection ifNil: [#()])
			do: [:o | self addMorphBack: o]]
]

{ #category : #'as yet unclassified' }
SBCollection >> isArtefact [

	^ true
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
SBCollection >> objectInterfaceNear: aBlock at: aSymbol [

	^ SBInterfaces topLevel
]

{ #category : #'as yet unclassified' }
SBCollection >> symbols [

	^ #('{' '}')
]
