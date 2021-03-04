Class {
	#name : #SBStAssignment,
	#superclass : #SBStASTNode,
	#instVars : [
		'pc'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStAssignment >> binding [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBStAssignment >> binding: aBlock value: anotherBlock [

	self removeAllMorphs.
	self addMorphBack: aBlock.
	self addMorphBack: (SBStringMorph new contents: ':=').
	self addMorphBack: anotherBlock
]

{ #category : #converting }
SBStAssignment >> childSandblocksDo: aBlock [

	aBlock value: self firstSubmorph.
	self submorphCount = 3 ifTrue: [
		aBlock value: self lastSubmorph]
]

{ #category : #'as yet unclassified' }
SBStAssignment >> expression [

	^ self lastSubmorph
]

{ #category : #'as yet unclassified' }
SBStAssignment >> initialize [

	super initialize.
	
	pc := 0
]

{ #category : #'as yet unclassified' }
SBStAssignment >> isAssignment [

	^ true
]

{ #category : #converting }
SBStAssignment >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBStAssignment >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			self binding layoutCommands.
			SBAlgebraCommand gap.
			SBAlgebraCommand morph data: self submorphs second.
			SBAlgebraCommand indent data: {
				SBAlgebraCommand softLineOrGap.
				self expression layoutCommands}}
]

{ #category : #converting }
SBStAssignment >> pc [

	^ pc
]

{ #category : #converting }
SBStAssignment >> pc: aNumber [

	pc := aNumber
]

{ #category : #converting }
SBStAssignment >> printOn: aStream [

	aStream nextPutAll: 'assignment to '.
	aStream nextPutAll: self firstSubmorph contents
]

{ #category : #'as yet unclassified' }
SBStAssignment >> symbols [

	^ self colorPolicy symbolsForAssignment: self
]

{ #category : #'as yet unclassified' }
SBStAssignment >> useAsMessageSend [
	<action>
	
	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
		target: self;
		replacer: (SBStMessageSend new receiver: (SBStName contents: 'self') selector: self binding contents asSymbol asSimpleSetter arguments: {self expression}))
]

{ #category : #testing }
SBStAssignment >> wantsExtraSpace [

	^ false
]

{ #category : #converting }
SBStAssignment >> writeSourceOn: aStream [

	aStream nextPut: $(.
	self binding writeSourceOn: aStream.
	aStream nextPutAll: ' := '.
	self expression writeSourceOn: aStream.
	aStream nextPut: $)
]
