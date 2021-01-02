Class {
	#name : #SBJsKeywordBlock,
	#superclass : #SBJsBlockScope,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsKeywordBlock class >> validBlockKeywords [

	^ #('if' 'while' 'else' 'else if' 'elseif' 'function' 'for' 'function*')
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> addHeaderBlock [
	<action>
	<actionValidIf: #dynamicArity>
	
	self sandblockEditor
		do: (self insertCommandRequest: true near: nil);
		startInput: self sandblockEditor selection at: 9e8 replacingContents: false
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> arity [

	self contents = 'for' ifTrue: [^ 3].
	self contents = 'function' ifTrue: [^ self header size].
	^ 1
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> binding: aString for: block class: aClass ifPresent: aBlock [

	self contents = 'function' ifTrue: [
		self header detect: [:arg | arg contents = aString] ifFound: [:arg | ^ aBlock value: arg] ifNone: []].
	
	(self contents = 'for' and: [self header first isDeclaration and: [self header first lhs contents = aString]]) ifTrue: [
		^ aBlock value: self header first lhs].
	
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> childSandblocksDo: aBlock [

	self header do: aBlock.
	super childSandblocksDo: aBlock
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> condition [

	^ self submorphs third
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

	^ (aBlock = self condition and: [self fixedArity])
		ifTrue: [nil] ifFalse: [super deleteCommandFor: aBlock]
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> dynamicArity [

	^ self fixedArity not
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> fixedArity [

	^ self contents ~= 'function'
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> header [

	^ self submorphs viewFrom: 3 to: 1 + ((self submorphs viewFrom: 3) findFirst: [:m | m isSandblock not])
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> keyStroke: anEvent [

	self currentTextMorph keyStroke: anEvent
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> keyword: aString [

	self addMorphBack: (SBOwnTextMorph new contents: aString).
	self addMorphBack: (SBStringMorph new contents: ' (').
	1 to: self arity do: [:i | self addMorphBack: self newNullBlock].
	self addMorphBack: (SBStringMorph new contents: ') {').
	self statements: {self newNullBlock}
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
			SBAlgebraCommand group data: (self header collect: #layoutCommands separatedBy: [SBAlgebraCommand gap]).
			SBAlgebraCommand morph data: (self submorphs at: self arity + 3).
			SBAlgebraCommand indent data: 
				{SBAlgebraCommand hardOrSoftline: self statements size > 0}, self layoutCommandsForStatements}
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> printOn: aStream [

	aStream nextPutAll: self contents
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

	^ self submorphs viewAllButFirst: 3 + self arity
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> statementsIndex [

	^ 4 + self arity
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
