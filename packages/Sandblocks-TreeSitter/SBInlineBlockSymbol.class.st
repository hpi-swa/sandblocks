Class {
	#name : #SBInlineBlockSymbol,
	#superclass : #SBInlineBlock,
	#instVars : [
		'type',
		'field'
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
	self addMorphBack: ((factory shouldBlockInline: type)
		ifTrue: [factory instantiateTemplate: type]
		ifFalse: [
			SBTSUnknown new
				template: [factory getTemplate: type];
				type: type factory: factory])
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> buildEmpty [

	^ self class new
		type: self type factory: factory;
		field: self field
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> candidatesForWrappingOn: aStream [

	(factory isSuperType: type) ifTrue: [aStream nextPut: self].
	super candidatesForWrappingOn: aStream
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> childrenForQueryDo: aBlock [

	aBlock value: self
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
SBInlineBlockSymbol >> field [

	^ field
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> field: aString [

	field := aString
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
SBInlineBlockSymbol >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self firstSubmorph layoutCommands}
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> newEmptyChildNear: aBlock before: aBoolean [

	^ (self firstSubmorph isKindOf: SBInlineBlockRepeat)
		ifTrue: [self firstSubmorph newEmptyChildNear: aBlock before: aBoolean]
		ifFalse: [super newEmptyChildNear: aBlock before: aBoolean]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> ownerWithColor [

	^ highlight ifNil: [self owner ifNotNil: [:o | o ownerWithColor]] ifNotNil: [self]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> printTitleOn: aStream [

	SBToggledCode comment: '' active: 0 do: {
		[((factory shouldBlockInline: type) and: [self hasSubmorphs and: [self firstSubmorph isUnknown not]]) ifTrue: [^ self firstSubmorph printTitleOn: aStream]]}.
	aStream nextPutAll: type
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> takeParsedFrom: aCursor [

	^ (factory type: aCursor type compatibleWith: type)
		ifTrue: [ | descend didDescend |
			descend := aCursor type = type.
			didDescend := false.
			
			descend ifTrue: [didDescend := aCursor gotoFirstChild].
			(self template takeParsedFrom: aCursor)
				ifNotNil: [:m |
					didDescend ifTrue: [
						aCursor gotoParent.
						aCursor gotoNextSibling].
					self buildEmpty addMorphBack: m]
				ifNil: [nil]]
		ifFalse: [nil]
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

	type := aSymbol.
	factory := aFactory
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> type: aSymbol factory: aFactory block: aMorph [

	type := aSymbol.
	factory := aFactory.
	self addMorphBack: aMorph
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> type: aSymbol factory: aFactory visitedSymbols: aSet [

	aSet add: aSymbol.
	self type: aSymbol factory: aFactory
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> writeSourceOn: aStream [

	self firstSubmorph writeSourceOn: aStream
]
