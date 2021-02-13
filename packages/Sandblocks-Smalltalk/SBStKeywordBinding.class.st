Class {
	#name : #SBStKeywordBinding,
	#superclass : #SBStNameBehavior,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStKeywordBinding >> attached: aName [

	super attached: aName.
	
	aName currentTextMorph emphasis: TextEmphasis underlined
]

{ #category : #'as yet unclassified' }
SBStKeywordBinding >> contentsChanged [

	(self contents = 'true' or: [self contents = 'false'])
		ifTrue: [^ self block behavior: SBStBoolean new].
	
	self block isReserved
		ifFalse: [^ self block behavior: SBStBinding new]
]

{ #category : #'as yet unclassified' }
SBStKeywordBinding >> guessedClass [

	self contents = 'self' ifTrue: [^ self block containingArtefact relatedClass].
	self contents = 'super' ifTrue: [^ self block containingArtefact relatedClass superclass].
	self contents = 'thisContext' ifTrue: [^ Context].
	self contents = 'nil' ifTrue: [^ UndefinedObject].
	self contents  = 'false' ifTrue: [^ False].
	self contents = 'true' ifTrue: [^ True].
	^ nil
]

{ #category : #'as yet unclassified' }
SBStKeywordBinding >> inputCommandClass [

	^ SBInputCommand
]

{ #category : #'as yet unclassified' }
SBStKeywordBinding >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBStKeywordBinding >> isKeyword [

	^ true
]

{ #category : #'as yet unclassified' }
SBStKeywordBinding >> isLiteralBlock [

	^ self contents = 'nil'
]

{ #category : #'as yet unclassified' }
SBStKeywordBinding >> printBlockOn: aStream [

	aStream nextPutAll: 'special binding '.
	aStream nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBStKeywordBinding >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForKeywordBinding: self block
]

{ #category : #'as yet unclassified' }
SBStKeywordBinding >> valid [

	^ true
]