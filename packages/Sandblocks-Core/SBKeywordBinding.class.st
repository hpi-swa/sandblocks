Class {
	#name : #SBKeywordBinding,
	#superclass : #SBNameBehavior,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBKeywordBinding >> attached: aName [

	super attached: aName.
	
	aName currentTextMorph emphasis: TextEmphasis underlined
]

{ #category : #'as yet unclassified' }
SBKeywordBinding >> contentsChanged [

	(self contents = 'true' or: [self contents = 'false'])
		ifTrue: [^ self block behavior: SBBoolean new].
	
	self block isReserved
		ifFalse: [^ self block behavior: SBBinding new]
]

{ #category : #'as yet unclassified' }
SBKeywordBinding >> guessedClass [

	self contents = 'self' ifTrue: [^ self block containingArtefact methodClass].
	self contents = 'super' ifTrue: [^ self block containingArtefact methodClass superclass].
	self contents = 'thisContext' ifTrue: [^ Context].
	self contents = 'nil' ifTrue: [^ UndefinedObject].
	self contents  = 'false' ifTrue: [^ False].
	self contents = 'true' ifTrue: [^ True].
	^ nil
]

{ #category : #'as yet unclassified' }
SBKeywordBinding >> inputCommandClass [

	^ SBInputCommand
]

{ #category : #'as yet unclassified' }
SBKeywordBinding >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBKeywordBinding >> isKeyword [

	^ true
]

{ #category : #'as yet unclassified' }
SBKeywordBinding >> isLiteralBlock [

	^ self contents = 'nil'
]

{ #category : #'as yet unclassified' }
SBKeywordBinding >> printBlockOn: aStream [

	aStream nextPutAll: 'special binding '.
	aStream nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBKeywordBinding >> valid [

	^ true
]
