Class {
	#name : #SBJsGrammarHandler,
	#superclass : #SBGrammarHandler,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsGrammarHandler >> checkKeyword: aString for: aBlock [

	(SBJsKeywordBlock validBlockKeywords includes: aString) ifTrue: [ | block |
		block := SBJsKeywordBlock new keyword: aString condition: aBlock newNullBlock branchStatements: {aBlock newNullBlock}.
		self replace: aBlock with: block.
		block inputNextUnknown].
	
	aString = 'let' ifTrue: [
		self replace: aBlock with: (SBJsDeclaration new lhs: aBlock newNullBlock rhs: aBlock newNullBlock)]
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
	
	char = $. ifTrue: [
		^ self wrap: aBlock do: [:outer :inner | outer lhs: inner rhs: ''] with: SBJsDereference new].
	char = $( ifTrue: [
		^ SBJsMethodCall new in: [:call | self wrap: aBlock do: [:outer :inner | outer method: inner arguments: {call newNullBlock deleteIfDismissed: true}] with: call]].
	((SBJsBinaryOperator validBinaryOperators collect: #first) includes: char) ifTrue: [
		^ self wrap: aBlock do: [:outer :inner | outer lhs: inner operator: char asString rhs: outer newNullBlock] with: SBJsBinaryOperator new].
	char = Character space ifTrue: [
		self checkKeyword: aBlock contents for: aBlock]
]
