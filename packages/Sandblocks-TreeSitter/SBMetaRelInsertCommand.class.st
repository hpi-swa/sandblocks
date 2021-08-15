Class {
	#name : #SBMetaRelInsertCommand,
	#superclass : #SBRelInsertCommand,
	#instVars : [
		'factory',
		'slot'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaRelInsertCommand >> do [

	morph := morph ifNil: [factory unknownFor: slot].
	^ super do
]

{ #category : #'as yet unclassified' }
SBMetaRelInsertCommand >> factory [

	^ factory
]

{ #category : #'as yet unclassified' }
SBMetaRelInsertCommand >> hasSamePositionAs: aCommand [

	^ (aCommand isKindOf: self class) and: [aCommand factory = self factory and: [(aCommand slot hasSameStructureAs: self slot) and: [super hasSamePositionAs: aCommand]]]
]

{ #category : #'as yet unclassified' }
SBMetaRelInsertCommand >> near: aBlock before: aBoolean in: aContainer factory: aFactory slot: aSlot [

	super near: aBlock before: aBoolean in: aContainer morph: nil.
	factory := aFactory.
	slot := aSlot
]

{ #category : #'as yet unclassified' }
SBMetaRelInsertCommand >> slot [

	^ slot
]

{ #category : #'as yet unclassified' }
SBMetaRelInsertCommand >> title [

	^ 'insert ', slot objectInterface
]
