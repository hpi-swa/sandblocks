Class {
	#name : #SBOhmRule,
	#superclass : #SBOhmASTNode,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBOhmRule >> allUsages [

	^ self parentSandblock allBlocksSelect: [:b | b isIdentifier and: [b valid and: [b associatedRule = self]]]
]

{ #category : #'as yet unclassified' }
SBOhmRule >> currentTextMorph [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBOhmRule >> expression [

	^ self lastSubmorph
]

{ #category : #'as yet unclassified' }
SBOhmRule >> initialize [

	super initialize.
	
]

{ #category : #'as yet unclassified' }
SBOhmRule >> isRule [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmRule >> key [

	^ self name
]

{ #category : #'as yet unclassified' }
SBOhmRule >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand gap])
]

{ #category : #'as yet unclassified' }
SBOhmRule >> name [

	^ self currentTextMorph contents
]

{ #category : #'as yet unclassified' }
SBOhmRule >> name: aString alternatives: aBlock [

	self addMorphBack: ((SBOwnTextMorph new placeholderText: 'name') contents: aString).
	self addMorphBack: (SBStringMorph new contents: ' = ').
	self addMorphBack: aBlock
]

{ #category : #'as yet unclassified' }
SBOhmRule >> wantsInput [

	^ self contents isEmpty
]

{ #category : #'as yet unclassified' }
SBOhmRule >> writeSourceOn: aStream [

	aStream nextPutAll: self name.
	aStream nextPutAll: ' = '.
	self expression writeSourceOn: aStream
]
