Class {
	#name : #SBTSRelInsertCommand,
	#superclass : #SBRelInsertCommand,
	#instVars : [
		'element'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBTSRelInsertCommand >> do [

	morph := morph ifNil: [element veryDeepCopy].
	super do.
	^ morph firstBlock
]

{ #category : #'as yet unclassified' }
SBTSRelInsertCommand >> element [

	^ element
]

{ #category : #'as yet unclassified' }
SBTSRelInsertCommand >> hasSamePositionAs: aCommand [

	^ (aCommand isKindOf: self class) and: [aCommand element = self element and: [super hasSamePositionAs: aCommand]]
]

{ #category : #'as yet unclassified' }
SBTSRelInsertCommand >> near: aBlock before: aBoolean in: aContainer morph: aMorph [

	element := aMorph.
	super near: aBlock before: aBoolean in: aContainer morph: nil
]

{ #category : #'as yet unclassified' }
SBTSRelInsertCommand >> title [

	^ 'insert ', element title
]
