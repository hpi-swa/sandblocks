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
SBInlineBlockSymbol >> buildPartial: anOptions with: aString [

	^ (factory getTemplate: type) buildPartial: anOptions with: aString
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> currentTextMorph [

	self submorphsDo: [:m | (m isKindOf: SBInlineBlockText) ifTrue: [^ m currentTextMorph]].
	^ nil
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
SBInlineBlockSymbol >> inline [

	^ SBToggledCode comment: '' active: 2 do: {[false]. [self inlineIfPossible]}
]

{ #category : #'as yet unclassified' }
SBInlineBlockSymbol >> instantiate [

	^ (factory isSuperType: type)
		ifTrue: [factory instantiateTemplate: type]
		ifFalse: [
			self veryDeepCopy
				removeAllMorphs;
				addMorphBack: (factory instantiateTemplate: type)]
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
SBInlineBlockSymbol >> type: aSymbol factory: aFactory visitedSymbols: aSet [

	| tryExpand template |
	tryExpand := (aSet includes: aSymbol) not.
	aSet add: aSymbol.
	
	type := aSymbol.
	factory := aFactory.
	
	self addMorphBack: (SBToggledCode comment: '' active: 2 do: {
		[SBTSUnknown new template: [factory getTemplate: type visitedSymbols: aSet]].
		[
			(tryExpand and: [
				template := factory getTemplate: type visitedSymbols: aSet.
				template notNil and: [template isUnambiguous]])
				ifTrue: [template veryDeepCopy]
				ifFalse: [SBTSUnknown new template: [factory getTemplate: type visitedSymbols: aSet]]]})
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
