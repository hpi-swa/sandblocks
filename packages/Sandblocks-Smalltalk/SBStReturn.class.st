Class {
	#name : #SBStReturn,
	#superclass : #SBStASTNode,
	#instVars : [
		'pc'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #testing }
SBStReturn >> canAppearInBlockBody [

	^ true
]

{ #category : #accessing }
SBStReturn >> expression [

	^ self firstSubmorph
]

{ #category : #accessing }
SBStReturn >> expression: aBlock [

	self removeAllMorphs.
	self addMorphBack: aBlock
]

{ #category : #'initialize-release' }
SBStReturn >> initialize [

	super initialize.
	
	pc := 0
]

{ #category : #testing }
SBStReturn >> isExpression [

	^ true
]

{ #category : #testing }
SBStReturn >> isReturn [

	^ true
]

{ #category : #layout }
SBStReturn >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self expression layoutCommands}
]

{ #category : #accessing }
SBStReturn >> pc [

	^ pc
]

{ #category : #accessing }
SBStReturn >> pc: aNumber [

	pc := aNumber
]

{ #category : #'colors and color policies' }
SBStReturn >> preferredColorIn: aColorPolicy [

	^ aColorPolicy important
]

{ #category : #printing }
SBStReturn >> printOn: aStream [

	aStream nextPutAll: 'return '.
	self firstSubmorph printOn: aStream
]

{ #category : #drawing }
SBStReturn >> symbols [

	^ self colorPolicy symbolsForReturn: self
]

{ #category : #testing }
SBStReturn >> valid [

	^ self containingStatement = self and: [(self containingBlock statements findLast: [:stmt | stmt isExpression or: [stmt isSmalltalk and: [stmt isReturn]]]) = (self containingBlock statements indexOf: self)]
]

{ #category : #drawing }
SBStReturn >> wantsExtraSpace [

	^ false
]

{ #category : #printing }
SBStReturn >> writeSourceOn: aStream [

	aStream nextPutAll: '^ '.
	self expression writeSourceOn: aStream
]
