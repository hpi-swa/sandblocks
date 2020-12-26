Class {
	#name : #SBJsKeywordBlock,
	#superclass : #SBJsBlockScope,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsKeywordBlock class >> validBlockKeywords [

	^ #('if' 'while' 'else' 'else if' 'elseif')
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> branch [

	^ self lastSubmorph
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> childSandblocksDo: aBlock [

	aBlock value: self condition.
	super childSandblocksDo: aBlock
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> condition [

	^ self submorphs third
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> condition: aBlock branchStatements: aCollection [

	self addMorphBack: (SBOwnTextMorph new contents: 'if').
	self addMorphBack: (SBStringMorph new contents: ' (').
	self addMorphBack: aBlock.
	self addMorphBack: (SBStringMorph new contents: ') {').
	self statements: aCollection
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> contents [

	^ self currentTextMorph contents
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> contents: aString [

	self currentTextMorph contents: aString
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> currentTextMorph [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> deleteCommandFor: aBlock [

	^ aBlock = self condition
		ifTrue: [nil] ifFalse: [super deleteCommandFor: aBlock]
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> keyStroke: anEvent [

	self currentTextMorph keyStroke: anEvent
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> keyword: aString condition: aBlock branchStatements: aCollection [

	self addMorphBack: (SBOwnTextMorph new contents: aString).
	self addMorphBack: (SBStringMorph new contents: ' (').
	self addMorphBack: aBlock.
	self addMorphBack: (SBStringMorph new contents: ') {').
	self statements: aCollection
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			SBAlgebraCommand morph data: self submorphs first.
			SBAlgebraCommand morph data: self submorphs second.
			self condition layoutCommands.
			SBAlgebraCommand morph data: self submorphs fourth.
			SBAlgebraCommand indent data: 
				{SBAlgebraCommand hardOrSoftline: self statements size > 0}, self layoutCommandsForStatements}
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := (SBInputCommand newOrEditFor: self containingArtefact)
		oldMorph: self;
		previousText: self currentTextMorph contents;
		yourself.
	
	aBoolean
		ifTrue: [self currentTextMorph contents: ''; moveCursorTo: 0]
		ifFalse: [self currentTextMorph moveCursorTo: aNumber].
	
	^ cmd
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> statements [

	^ self submorphs viewAllButFirst: 4
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> statementsIndex [

	^ 5
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> stopEditing: aCommand [

	aCommand newText: self currentTextMorph contents.
	
	(self class validBlockKeywords includes: self contents)
		ifFalse: [ | variable |
			variable := self contents ifEmpty: [self newNullBlock] ifNotEmpty: [SBJsVariable new contents: self currentTextMorph contents].
			self replaceBy: variable.
			aCommand newMorph: variable]
		ifTrue: [aCommand newMorph: self].
	
	self currentTextMorph stopEditing
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> symbols [

	^ #(nil '}')
]
