Class {
	#name : #SBValueList,
	#superclass : #SBJsASTNode,
	#instVars : [
		'symbols'
	],
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBValueList >> centerAlignSymbols [

	^ true
]

{ #category : #'as yet unclassified' }
SBValueList >> childSandblocksDo: aBlock [

	self submorphsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBValueList >> extent: aPoint [

	super extent: (aPoint max: self layoutInset asEdgeInsets x @ self minimumHeight)
]

{ #category : #'as yet unclassified' }
SBValueList >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBValueList >> initialize [

	symbols := #(nil nil).
	super initialize
]

{ #category : #'as yet unclassified' }
SBValueList >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		index: (self childSandblocks indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
		container: self;
		morph: self newNullBlock;
		shouldMergeWithNext: true;
		yourself
]

{ #category : #'as yet unclassified' }
SBValueList >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self values collect: #layoutCommands separatedBy: [SBAlgebraCommand softLineOrGap])
]

{ #category : #'as yet unclassified' }
SBValueList >> minimumHeight [

	^ TextStyle defaultFont height + 4
]

{ #category : #'as yet unclassified' }
SBValueList >> newNullBlock [

	^ self owner isBlockBody ifTrue: [SBJsVariable new] ifFalse: [super newNullBlock]
]

{ #category : #'as yet unclassified' }
SBValueList >> startInputAt: aNumber replacingContents: aBoolean [

	| new |
	new := self newNullBlock.
	self addMorphBack: new.
	self sandblockEditor replaceInput: new.
	^ new startInputAt: aNumber replacingContents: aBoolean
]

{ #category : #'as yet unclassified' }
SBValueList >> symbols [

	^ symbols
]

{ #category : #'as yet unclassified' }
SBValueList >> symbols: aCollection [

	symbols := aCollection
]

{ #category : #'as yet unclassified' }
SBValueList >> values [

	^ self submorphs
]

{ #category : #'as yet unclassified' }
SBValueList >> values: aCollection [

	self addAllMorphs: aCollection
]

{ #category : #'as yet unclassified' }
SBValueList >> wantsExtraSpace [

	^ false
]
