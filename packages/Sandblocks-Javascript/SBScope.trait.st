Trait {
	#name : #SBScope,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBScope classSide >> test [

]

{ #category : #'as yet unclassified' }
SBScope >> binding: aString for: block class: aClass ifPresent: aBlock [

	self statements detect: [:stmt | stmt isDeclaration and: [stmt lhs contents = aString]] ifFound: [:stmt | ^ aBlock value: stmt] ifNone: [].
	
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBScope >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		index: (self childSandblocks indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
		container: self;
		morph: self newNullBlock;
		shouldMergeWithNext: true;
		yourself
]

{ #category : #'as yet unclassified' }
SBScope >> isScope [

	^ true
]

{ #category : #'as yet unclassified' }
SBScope >> statements [

	^ self submorphs
]
