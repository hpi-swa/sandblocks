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
SBInlineBlockSymbol >> allElementsDo: aBlock [

	aBlock value: self
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> buildCopy [

	^ self buildEmpty addMorphBack: self firstSubmorph buildCopy
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> buildDefaultIn: anExplore [

	super buildDefaultIn: anExplore.
	self addMorphBack: ((factory shouldBlockInline: self type)
		ifTrue: [factory instantiateTemplate: self type]
		ifFalse: [
			SBTSUnknown new
				template: [factory getTemplate: self type];
				type: self type factory: factory])
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> buildEmpty [

	^ self class new
		type: self type factory: factory;
		field: self field
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> buildWithFields: aStream alternatives: aDictionary [

	self isSuperType ifTrue: [^ true].
	aStream peek second isMorph ifFalse: [^ false].
	
	^ ((aStream peek second isKindOf: SBInlineBlockSymbol) and: [self type = aStream peek second type])
		ifTrue: [ | block |
			self assert: self hasSubmorphs not.
			block := aStream next second.
			self addMorphBack: (block type = self type
				ifTrue: [block firstSubmorph buildCopy]
				ifFalse: [self template buildEmpty addMorphBack: block]).
			true]
		ifFalse: [false]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> candidatesForWrappingOn: aStream [

	(factory isSuperType: self type) ifTrue: [aStream nextPut: self].
	super candidatesForWrappingOn: aStream
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> childrenForQueryDo: aBlock [

	(factory isSuperType: self type)
		ifTrue: [self firstSubmorph childrenForQueryDo: aBlock]
		ifFalse: [aBlock value: self]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> childrenIn: anExplore [

	((anExplore expandSymbol: self) not and: [self isSuperType not]) ifTrue: [^ #()].
	^ (anExplore notNil and: [
		SBToggledCode
			comment: ''
			active: 1
			do: {[anExplore canVisitSymbol: self type]. [anExplore hasVisitedSymbol: self type factory: factory]}])
		ifTrue: [{self template}]
		ifFalse: [{SBInlineBlockNever new}]
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
SBInlineBlockSymbol >> firstDifferingBlocksWith: aMorph do: aBlock [

	self class = aMorph class ifFalse: [^ aBlock value: self value: aMorph].
	self type = aMorph type ifFalse: [^ aBlock value: self value: aMorph].
	^ self firstSubmorph firstDifferingBlocksWith: aMorph firstSubmorph do: aBlock
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

	^ self repeaterChild ifNotNil: [:c | c insertCommandRequest: aMorph near: aBlock before: aBoolean]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> instantiate [

	^ (factory isSuperType: self type)
		ifTrue: [factory instantiateTemplate: self type]
		ifFalse: [self buildEmpty addMorphBack: (factory instantiateTemplate: self type)]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> isHidden [

	^ self type first = $_ or: [factory isSuperType: self type]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> isStatementContainer [

	^ factory isStatementContainer: self type
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> isSuperType [

	^ factory isSuperType: self type
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> isTemplate [

	^ self hasSubmorphs not
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> labelDifferenceOf: aMorph do: aBlock [

	self type = aMorph type ifFalse: [
		aBlock value: self value: aMorph.
		^ false].
	(self firstSubmorph labelDifferenceOf: aMorph firstSubmorph do: aBlock) ifFalse: [
		aBlock value: self value: aMorph.
		^ false].
	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self firstSubmorph layoutCommands}
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> newEmptyChildNear: aBlock before: aBoolean [

	^ SBToggledCode comment: '' active: 1 do: {
		[self repeaterChild newEmptyChildNear: aBlock before: aBoolean].
		[
			aBlock ifNotNil: [(aBlock ownerThatIsA: SBInlineBlockRepeat) ifNotNil: [:container | ^ container newEmptyChildNear: aBlock before: aBoolean]].
			^ (self firstSubmorph isKindOf: SBInlineBlockRepeat)
				ifTrue: [self firstSubmorph newEmptyChildNear: aBlock before: aBoolean]
				ifFalse: [nil]]}
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> newNullBlock [

	| parent unknown |
	parent := self inlineRoot.
	unknown := SBTSUnknown new template: [parent buildEmpty].
	(parent isKindOf: self class) ifTrue: [unknown type: parent type factory: factory].
	^ unknown
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> ownerWithColor [

	^ highlight ifNil: [self owner ifNotNil: [:o | o ownerWithColor]] ifNotNil: [self]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> printSExprOn: aStream depth: aNumber [

	| any |
	aStream nextPutAll: '('.
	aStream nextPutAll: self type.
	any := false.
	self childSymbolsDo: [:morph |
		any ifFalse: [any := true].
		aStream crtab: aNumber + 1.
		morph printSExprOn: aStream depth: aNumber + 1].
	any ifTrue: [aStream crtab: aNumber].
	aStream nextPutAll: ')'
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> printTitleOn: aStream [

	SBToggledCode comment: '' active: 0 do: {
		[((factory shouldBlockInline: self type) and: [self hasSubmorphs and: [self firstSubmorph isUnknown not]]) ifTrue: [^ self firstSubmorph printTitleOn: aStream]]}.
	aStream nextPutAll: self type
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> takeParseFrom: aCursor [

	aCursor type = self type ifTrue: [
		" if there was more on this level, fail "
		aCursor gotoNextSibling ifTrue: [^ false].
		(self valueOfProperty: #didDescend) ifTrue: [aCursor gotoParent]].
	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> takeParsedFrom: aCursor [

	^ (factory type: aCursor type compatibleWith: self type)
		ifTrue: [ | descend didDescend |
			" if types were only compatible not matching this is a hidden symbol "
			descend := aCursor type = self type.
			didDescend := false.
			
			descend ifTrue: [didDescend := aCursor gotoFirstChild].
			(self template takeParsedFrom: aCursor)
				ifNotNil: [:m |
					didDescend ifTrue: [
						" if there was more we did a mistake and shouldn't go back up "
						aCursor gotoNextSibling ifTrue: [^ nil].
						
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
SBInlineBlockSymbol >> unwrapSuperType [

	^ self isSuperType ifTrue: [self firstSubmorph unwrapSuperType] ifFalse: [self]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> writeSourceOn: aStream [

	self firstSubmorph writeSourceOn: aStream
]
