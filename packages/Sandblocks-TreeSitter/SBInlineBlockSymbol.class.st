Class {
	#name : #SBInlineBlockSymbol,
	#superclass : #SBInlineBlock,
	#instVars : [
		'type',
		'factory'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> buildCopy [

	^ self buildEmpty addMorphBack: self firstSubmorph buildCopy
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> buildDefaultIn: anExplore [

	super buildDefaultIn: anExplore.
	self addMorphBack: (SBTSUnknown new
		template: [factory getTemplate: type visitedSymbols: Set new];
		type: type factory: factory)
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> buildEmpty [

	^ self class new type: self type factory: factory visitedSymbols: Set new
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> buildFor: aString matchFullToken: aBoolean options: anOptions [

	^ (anOptions hasVisitedSymbol: self type) ifTrue: [nil] ifFalse: [
		anOptions addVisitedSymbol: self type.
		(factory getTemplate: self type)
			buildFor: aString
			matchFullToken: aBoolean
			options: anOptions]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> buildPartial: anOptions with: aString [

	^ (factory getTemplate: type) buildPartial: anOptions with: aString
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> candidatesForWrappingOn: aStream [

	(factory isSuperType: type) ifTrue: [aStream nextPut: self].
	super candidatesForWrappingOn: aStream
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> childrenIn: anExplore [

	^ (anExplore notNil and: [anExplore hasVisitedSymbol: self type factory: factory])
		ifTrue: [{SBInlineBlockNever new}]
		ifFalse: [
			anExplore ifNotNil: [anExplore addVisitedSymbol: self type].
			{self template}]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> deleteTargetFor: aBlock [

	^ self owner deleteTargetFor: self
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> factory: aFactory [

	factory := aFactory
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> fixedNumberOfChildren [

	^ (self firstSubmorph isKindOf: SBInlineBlockRepeat) not
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> hasSameContentsAs: aBlock [

	^ (super hasSameStructureAs: aBlock) and: [self type = aBlock type and: [self firstSubmorph hasSameContentsAs: aBlock firstSubmorph]]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> hasSameStructureAs: aBlock [

	^ ((super hasSameStructureAs: aBlock) and: [self type = aBlock type]) or: [self template hasSameStructureAs: aBlock]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> includesNestedSameStructure: aBlock [

	(super includesNestedSameStructure: aBlock) ifTrue: [^ true].
	
	self type = 'binary_operator' ifTrue: [self halt].
	((aBlock isKindOf: SBInlineBlockSymbol) and: [self type = aBlock type]) ifTrue: [^ true].
	
	Transcript showln: self type.
	^ (factory getTemplate: self type) includesNestedSameStructure: aBlock
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> inline [

	^ SBToggledCode
		comment: ''
		active: 1
		do: {[factory shouldBlockInline: self type]. [self inlineIfPossible]}
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	^ (self firstSubmorph isKindOf: SBInlineBlockRepeat)
		ifTrue: [self firstSubmorph insertCommandRequest: aMorph near: aBlock before: aBoolean]
		ifFalse: [super insertCommandRequest: aMorph near: aBlock before: aBoolean]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> instantiate [

	^ (factory isSuperType: type)
		ifTrue: [factory instantiateTemplate: type]
		ifFalse: [self buildEmpty addMorphBack: (factory instantiateTemplate: type)]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> isStatementContainer [

	^ factory isStatementContainer: type
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> isUnambiguous [

	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> newEmptyChildNear: aBlock before: aBoolean [

	^ (self firstSubmorph isKindOf: SBInlineBlockRepeat)
		ifTrue: [self firstSubmorph newEmptyChildNear: aBlock before: aBoolean]
		ifFalse: [super newEmptyChildNear: aBlock before: aBoolean]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> printTitleOn: aStream [

	SBToggledCode comment: '' active: 0 do: {
		[((factory shouldBlockInline: type) and: [self hasSubmorphs and: [self firstSubmorph isUnknown not]]) ifTrue: [^ self firstSubmorph printTitleOn: aStream]]}.
	aStream nextPutAll: type
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> takeStreamFrom: anObject [

	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> template [

	^ factory getTemplate: self type
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> triggersFor: aString matchFullToken: aBoolean options: anOptions [

	^ (anOptions hasVisitedSymbol: self type)
		ifTrue: [false]
		ifFalse: [
			anOptions addVisitedSymbol: self type.
			(factory getTemplate: self type)
				triggersFor: aString
				matchFullToken: aBoolean
				options: anOptions]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> type [

	^ type
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> type: aSymbol factory: aFactory [

	self type: aSymbol factory: aFactory visitedSymbols: Set new
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> type: aSymbol factory: aFactory block: aMorph [

	type := aSymbol.
	factory := aFactory.
	self addMorphBack: aMorph
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> type: aSymbol factory: aFactory visitedSymbols: aSet [

	| tryExpand |
	tryExpand := (aSet includes: aSymbol) not.
	aSet add: aSymbol.
	
	type := aSymbol.
	factory := aFactory
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> veryDeepCopyWith: deepCopier [

	| f copy |
	f := factory.
	factory := nil.
	copy := super veryDeepCopyWith: deepCopier.
	factory := f.
	copy factory: f.
	^ copy
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> writeSourceOn: aStream [

	self firstSubmorph writeSourceOn: aStream
]
