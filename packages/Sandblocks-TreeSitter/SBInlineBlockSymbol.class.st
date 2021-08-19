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

	| morph |
	morph := SBMetaBlock new factory: factory parentSlot: self.
	^ (factory getTemplate: type) buildPartial: anOptions with: aString
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

	| template tryExpand |
	tryExpand := (aSet includes: aSymbol) not.
	aSet add: aSymbol.
	
	type := aSymbol.
	factory := aFactory.
	template := factory getTemplate: type visitedSymbols: aSet.
	
	self addMorphBack: ((tryExpand and: [template isUnambiguous])
		ifTrue: [template]
		ifFalse: [SBTSUnknown new template: template])
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
