Class {
	#name : #SBJsGrammarHandler,
	#superclass : #SBGrammarHandler,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsGrammarHandler >> checkKeyword: aString for: aBlock [

	(SBJsKeywordBlock validBlockKeywords includes: aString) ifTrue: [ | block |
		block := SBJsKeywordBlock new keyword: aString.
		self replace: aBlock with: block mergeInput: false.
		block inputNextUnknown.
		^ true].
	
	(SBJsPrefixOperator validPrefixOperators includes: aString) ifTrue: [ | block |
		block := SBJsPrefixOperator new operator: aString rhs: aBlock newNullBlock.
		self replace: aBlock with: block mergeInput: false.
		block inputNextUnknown.
		^ true].
	
	aString = 'let' ifTrue: [
		self replace: aBlock with: (SBJsDeclaration new lhs: aBlock newNullBlock rhs: aBlock newNullBlock) mergeInput: false.
		^ true].
	
	aString = 'return' ifTrue: [
		self replace: aBlock with: (SBJsReturn new expression: (aBlock newNullBlock deleteIfDismissed: true)) mergeInput: false.
		^ true].
	
	^ false
]

{ #category : #'as yet unclassified' }
SBJsGrammarHandler >> perform: char for: aBlock empty: aBoolean [

	aBoolean ifTrue: [
		(char isDigit or: [char = $-]) ifTrue: [^ self replace: aBlock with: (SBJsNumber new contents: char asString)].
		(char isAlphaNumeric or: [char = $_]) ifTrue: [^ self replace: aBlock with: (SBJsVariable new contents: char asString)].
		char = $" ifTrue: [^ self replace: aBlock with: SBJsString new].
		char = $( ifTrue: [ ^ SBJsClosure new in: [:closure | self replace: aBlock with: (closure statements: {closure newNullBlock})]].
		" borrowed from Smalltalk "
		char = $^ ifTrue: [^ SBJsReturn new in: [:return | self replace: aBlock with: (return expression: return newNullBlock)]].
		char = ${ ifTrue: [^ self replace: aBlock with: SBJsObjectLiteral new]].
	
	"char = $. ifTrue: [
		^ self wrap: aBlock do: [:outer :inner | outer lhs: inner rhs: ''] with: SBJsDereference new]."
	"char = $( ifTrue: [
		^ SBJsMethodCall new in: [:call | self wrap: aBlock do: [:outer :inner | outer method: inner arguments: {call newNullBlock deleteIfDismissed: true}] with: call]]."
	
	((SBJsInfixOperator validInfixOperators collect: #first) includes: char) ifTrue: [
		^ self wrap: aBlock do: [:outer :inner | outer lhs: inner operator: char asString rhs: (outer newNullBlock deleteIfDismissed: char = $()] with: SBJsInfixOperator new].
	char = Character space ifTrue: [
		(self checkKeyword: aBlock contents for: aBlock) ifFalse: [
			self wrap: aBlock do: [:outer :inner | outer lhs: inner operator: '' rhs: outer newNullBlock] with: SBJsInfixOperator new]]
]

{ #category : #'as yet unclassified' }
SBJsGrammarHandler >> wrap: aBlock do: aWrapBlock with: anOuterBlock [

	super wrap: aBlock do: aWrapBlock with: anOuterBlock.
	anOuterBlock shouldRotateWhenJustAdded ifTrue: [
		anOuterBlock leftRotate.
		anOuterBlock inputNextUnknown]
]
