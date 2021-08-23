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
SBInlineBlockSymbol >> buildDefaultIn: anExplore [

	self addMorphBack: (SBTSUnknown new
		template: [factory getTemplate: type visitedSymbols: Set new];
		type: type)
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
SBInlineBlockSymbol >> buildIn: aMorph info: anObject [

	^ self
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> buildPartial: anOptions with: aString [

	^ (factory getTemplate: type) buildPartial: anOptions with: aString
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> childrenIn: anExplore [

	^ (SBToggledCode
		comment: ''
		active: 2
		do: {[false]. [anExplore hasVisitedSymbol: self type]})
		ifTrue: [{SBInlineBlockNever new}]
		ifFalse: [
			anExplore addVisitedSymbol: self type.
			{factory getTemplate: self type}]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> deleteTargetFor: aBlock [

	^ self owner deleteTargetFor: self
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> duplicateCleanTree [

	^ self veryDeepCopy removeAllMorphs
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> factory: aFactory [

	factory := aFactory
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> hasSameContentsAs: aBlock [

	^ (super hasSameStructureAs: aBlock) and: [self type = aBlock type and: [self firstSubmorph hasSameContentsAs: aBlock firstSubmorph]]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> hasSameStructureAs: aBlock [

	^ (super hasSameStructureAs: aBlock) and: [self type = aBlock type and: [self firstSubmorph hasSameStructureAs: aBlock firstSubmorph]]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> inline [

	^ SBToggledCode comment: '' active: 1 do: {[false]. [self inlineIfPossible]}
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> instantiate [

	^ (factory isSuperType: type)
		ifTrue: [factory instantiateTemplate: type]
		ifFalse: [self buildEmpty addMorphBack: (factory instantiateTemplate: type)]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> isUnambiguous [

	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> printTitleOn: aStream [

	aStream nextPutAll: type
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
	factory := aFactory.
	
	SBToggledCode comment: '' active: 0 do: {
		[
			self addMorphBack: (SBToggledCode comment: '' active: 2 do: {
				[SBTSUnknown new template: [factory getTemplate: type visitedSymbols: aSet]].
				[
					(tryExpand and: [
						template := factory getTemplate: type visitedSymbols: aSet.
						template notNil and: [template isUnambiguous]])
						ifTrue: [template veryDeepCopy]
						ifFalse: [SBTSUnknown new template: [factory getTemplate: type visitedSymbols: aSet]]]})]}
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
