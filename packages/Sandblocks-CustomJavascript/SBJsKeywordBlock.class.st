Class {
	#name : #SBJsKeywordBlock,
	#superclass : #SBJsBlockScope,
	#category : #'Sandblocks-CustomJavascript'
}

{ #category : #'as yet unclassified' }
SBJsKeywordBlock class >> validBlockKeywords [

	^ #('if' 'while' 'else' 'else if' 'elseif' 'function' 'for' 'function*' 'jsx')
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> arity [

	self contents = 'for' ifTrue: [^ 3].
	self contents = 'function' ifTrue: [^ self header size].
	self contents = 'jsx' ifTrue: [^ 2].
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

	^ ((self header includes: aBlock) and: [self fixedArity])
		ifTrue: [nil] ifFalse: [super deleteCommandFor: aBlock]
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> directAddHeaderBlock [
	
	self addMorph: self newNullBlock asElementNumber: self header size + 3
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
SBJsKeywordBlock >> header: aCollection [

	self header do: #delete.
	self addAllMorphs: aCollection after: self submorphs second
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> isExpression [

	^ self contents = 'jsx'
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
	self statements: {self newNullBlock label: 'body'}
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
			SBAlgebraCommand morph data: (self submorphs at: self header size + 3).
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
	cmd := SBJsKeywordBlockInputCommand new
		morph: self;
		previousContents: self currentTextMorph contents;
		previousOperands: self header;
		yourself.
	
	aBoolean
		ifTrue: [
			self currentTextMorph
				contents: '';
				moveCursorTo: 0]
		ifFalse: [self currentTextMorph moveCursorTo: aNumber].
	
	^ cmd
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> startInputCommand [

	^ SBJsKeywordBlockInputCommand new
		morph: self;
		previousContents: self currentTextMorph contents;
		previousOperands: self header;
		yourself
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> statements [

	^ self submorphs viewAllButFirst: 3 + self header size
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> statementsIndex [

	^ 4 + self header size
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> stopEditing: aCommand [

	aCommand contents: self currentTextMorph contents.
	
	((self class validBlockKeywords includes: self contents) or: [self statements notEmpty])
		ifFalse: [ | variable |
			variable := self contents
				ifEmpty: [self newNullBlock]
				ifNotEmpty: [SBJsVariable new contents: self currentTextMorph contents].
			self replaceBy: variable.
			aCommand newMorph: variable]
		ifTrue: [aCommand newMorph: self].
	
	self currentTextMorph stopEditing
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> symbols [

	^ #(nil '}')
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> valid [

	self contents = 'else' ifTrue: [^ (self adjacentBlock: -1) ifNotNil: [:adj | adj contents = 'if'] ifNil: [false]].
	^ true
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlock >> writeSourceOn: aStream [

	aStream nextPutAll: self contents; space; nextPut: $(.
	self header do: [:a | a writeSourceOn: aStream] separatedBy: [aStream nextPutAll: ', '].
	aStream nextPutAll: ') {'.
	self statements do: [:s | s writeSourceOn: aStream. aStream nextPut: $;; cr].
	aStream nextPut: $}
]
