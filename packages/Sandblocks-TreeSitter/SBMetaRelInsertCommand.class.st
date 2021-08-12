Class {
	#name : #SBMetaRelInsertCommand,
	#superclass : #SBRelInsertCommand,
	#instVars : [
		'objectInterface',
		'factory'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaRelInsertCommand >> do [

	morph := morph ifNil: [factory unknownFor: objectInterface].
	^ super do
]

{ #category : #'as yet unclassified' }
SBMetaRelInsertCommand >> factory [

	^ factory
]

{ #category : #'as yet unclassified' }
SBMetaRelInsertCommand >> hasSamePositionAs: aCommand [

	^ (aCommand isKindOf: self class) and: [aCommand factory = self factory and: [aCommand objectInterface = self objectInterface and: [super hasSamePositionAs: aCommand]]]
]

{ #category : #'as yet unclassified' }
SBMetaRelInsertCommand >> near: aBlock before: aBoolean in: aContainer factory: aFactory objectInterface: aSymbol [

	super near: aBlock before: aBoolean in: aContainer morph: nil.
	factory := aFactory.
	objectInterface := aSymbol
]

{ #category : #'as yet unclassified' }
SBMetaRelInsertCommand >> objectInterface [

	^ objectInterface
]

{ #category : #'as yet unclassified' }
SBMetaRelInsertCommand >> title [

	^ 'insert ', objectInterface
]
