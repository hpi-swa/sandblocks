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
		block := SBJsPrefixOperator new
			operator: aString
			rhs: (aBlock newNullBlock label: 'expr').
		self replace: aBlock with: block mergeInput: false.
		block inputNextUnknown.
		^ true].
	
	(#('let' 'var' 'const') includes: aString) ifTrue: [
		self
			replace: aBlock
			with: (SBJsDeclaration new
				binding: (aBlock newNullBlock label: 'name')
				value: (aBlock newNullBlock label: 'expr')
				declarationType: aString)
			mergeInput: false.
		^ true].
	
	^ false
]

{ #category : #'as yet unclassified' }
SBJsGrammarHandler >> perform: char for: aBlock empty: aBoolean [

	aBoolean ifTrue: [
		(char isDigit or: [char = $-]) ifTrue: [^ self replace: aBlock with: (SBJsNumber new contents: char asString)].
		(char isAlphaNumeric or: [char = $_]) ifTrue: [^ self replace: aBlock with: (SBJsVariable new contents: char asString)].
		(char = $" or: [char = $']) ifTrue: [^ self replace: aBlock with: SBJsString new].
		char = $( ifTrue: [ ^ SBJsClosure new in: [:closure | self replace: aBlock with: (closure statements: {closure newNullBlock label: 'body'})]].
		" borrowed from Smalltalk "
		char = $^ ifTrue: [^ SBJsPrefixOperator new contents: 'return'; in: [:return | self replace: aBlock with: (return expression: return newNullBlock)]].
		char = ${ ifTrue: [^ self replace: aBlock with: SBJsObjectLiteral new]].
	
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

{ #category : #actions }
SBJsGrammarHandler >> wrapAsArgument [
	<action>
	<actionValidIf: #isExpression>

	| operator |
	self flag: #todo. " figure out a way to make the terminology language dependent: the shortcut comes from Smalltalk "
	operator := SBJsPrefixOperator new.
	self block sandblockEditor
		do: ((SBWrapCommand newFor: self block containingArtefact)
			inner: self block;
			outer: operator;
			wrap: [:outer :inner | outer operator: '' rhs: inner]);
		startInput: operator at: 0 replacingContents: false
]

{ #category : #actions }
SBJsGrammarHandler >> wrapInDynamicArray [
	<action>
	<actionValidIf: #isExpression>
	
	| key |
	self flag: #todo. " figure out a way to make the terminology language dependent: the shortcut comes from Smalltalk where { is an array but in JS it's an object "
	key := self block newNullBlock.
	self block sandblockEditor
		do: ((SBWrapCommand newFor: self block containingArtefact)
			inner: self block;
			outer: SBJsObjectLiteral new;
			wrap: [:outer :inner | outer pairs: {key -> inner}]);
		startInput: key at: 0 replacingContents: false
]

{ #category : #actions }
SBJsGrammarHandler >> wrapInOperator [
	<action>
	<actionValidIf: #isExpression>
	
	| operator |
	self flag: #todo. " figure out a way to make the terminology language dependent: the shortcut comes from Smalltalk "
	operator := SBJsInfixOperator new.
	self block sandblockEditor
		do: ((SBWrapCommand newFor: self block containingArtefact)
			inner: self block;
			outer: operator;
			wrap: [:outer :inner | outer lhs: inner operator: '' rhs: operator newNullBlock]);
		startInput: operator at: 0 replacingContents: false
]

{ #category : #actions }
SBJsGrammarHandler >> wrapInReturn [
	<action>
	<actionValidIf: #isStatement>
	
	self block sandblockEditor do: ((SBWrapCommand newFor: self block containingArtefact)
		outer: (SBJsPrefixOperator new contents: 'return');
		inner: self block;
		wrap: [:outer :inner | outer expression: inner])
]
