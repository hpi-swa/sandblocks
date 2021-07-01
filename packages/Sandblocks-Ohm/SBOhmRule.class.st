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
SBOhmRule >> allUsagesDo: aBlock [

	^ self parentSandblock allBlocksDo: [:b | (b isIdentifier and: [b valid and: [b associatedRule = self]]) ifTrue: [aBlock value: b]]
]

{ #category : #'as yet unclassified' }
SBOhmRule >> containingRule [

	^ self
]

{ #category : #'as yet unclassified' }
SBOhmRule >> currentTextMorph [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBOhmRule >> expression [

	^ self lastSubmorph isSandblock ifTrue: [self lastSubmorph] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBOhmRule >> initialize [

	super initialize.
	
]

{ #category : #'as yet unclassified' }
SBOhmRule >> isLexical [

	^ self name first isLowercase
]

{ #category : #'as yet unclassified' }
SBOhmRule >> isPrimitive [

	self allBlocksDo: [:b | ((b isIdentifier and: [b isSimple not]) or: [b isTerminal and: [b contents size > 1]]) ifTrue: [^ false]].
	^ true
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
SBOhmRule >> name: aString [

	self currentTextMorph contents: aString
]

{ #category : #'as yet unclassified' }
SBOhmRule >> name: aString alternatives: aBlock [

	self addMorphBack: ((SBOwnTextMorph new placeholderText: 'name') contents: aString).
	self addMorphBack: (SBStringMorph new contents: ' = ').
	self addMorphBack: aBlock
]

{ #category : #'as yet unclassified' }
SBOhmRule >> printOn: aStream [

	aStream
		nextPutAll: 'rule ';
		nextPutAll: self name
]

{ #category : #'as yet unclassified' }
SBOhmRule >> wantsInput [

	^ self contents isEmpty
]

{ #category : #'as yet unclassified' }
SBOhmRule >> writeRascalSourceOn: aStream [

	aStream nextPutAll: 'syntax '.
	aStream nextPutAll: self name.
	aStream nextPutAll: ' = '.
	self expression isAlternative
		ifTrue: [self expression writeOnMultipleLinesOn: aStream]
		ifFalse: [self expression writeSourceOn: aStream].
	aStream nextPutAll: ';'
]

{ #category : #'as yet unclassified' }
SBOhmRule >> writeSourceOn: aStream [

	aStream nextPutAll: self name.
	self expression isAlternative ifTrue: [aStream crtab].
	aStream nextPutAll: ' = '.
	self expression isAlternative
		ifTrue: [self expression writeOnMultipleLinesOn: aStream]
		ifFalse: [self expression writeSourceOn: aStream]
]
