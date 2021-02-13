Class {
	#name : #SBStName,
	#superclass : #SBStLiteral,
	#instVars : [
		'behavior',
		'binding',
		'autoCast'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStName class >> contents: aString [

	^ self new contents: aString; yourself
]

{ #category : #'as yet unclassified' }
SBStName class >> instanceVariable: aString [

	^ (self contents: aString)
		behavior: SBStDeclarationForInstanceVariable new;
		yourself
]

{ #category : #'as yet unclassified' }
SBStName class >> newWith: aNameBehavior [

	^ self new
		behavior: aNameBehavior;
		yourself
]

{ #category : #'as yet unclassified' }
SBStName class >> poolDeclaration: aString [

	^ (self contents: aString)
		behavior: SBStDeclarationForPoolVariable new;
		yourself
]

{ #category : #'as yet unclassified' }
SBStName >> acceptInputEvent: anEvent [

	| char |
	char := anEvent keyCharacter.
	(char isAlphaNumeric or: [char = $_])
		ifTrue: [super acceptInputEvent: anEvent]
		ifFalse: [
			self isExpression ifTrue: [SBStGrammarHandler new perform: char for: self empty: false]]
]

{ #category : #'as yet unclassified' }
SBStName >> actionsProviders [

	^ super actionProviders, {self behavior}
]

{ #category : #'as yet unclassified' }
SBStName >> allUsagesDo: aBlock [

	^ self behavior resolveBinding ifNotNil: [:binding | binding allUsagesDo: aBlock]
]

{ #category : #'as yet unclassified' }
SBStName >> asSuggestionItem [

	^ self behavior asSuggestionItem
]

{ #category : #accessing }
SBStName >> autoCast [

	^ autoCast
]

{ #category : #accessing }
SBStName >> autoCast: aBoolean [

	autoCast := aBoolean
]

{ #category : #'as yet unclassified' }
SBStName >> behavior [

	^ behavior
]

{ #category : #'as yet unclassified' }
SBStName >> behavior: anObject [

	behavior class ~= anObject class ifTrue: [
		behavior := anObject.
		anObject attached: self]
]

{ #category : #'as yet unclassified' }
SBStName >> binding [

	^ binding
]

{ #category : #'as yet unclassified' }
SBStName >> binding: aBinding [

	binding := aBinding
]

{ #category : #'as yet unclassified' }
SBStName >> browse [

	^ self behavior browse
]

{ #category : #'as yet unclassified' }
SBStName >> castToUnknownWhenEmpty [

	^ self isExpression
]

{ #category : #'as yet unclassified' }
SBStName >> contentsChanged [

	self behavior contentsChanged.
	
	super contentsChanged
]

{ #category : #'as yet unclassified' }
SBStName >> doubleClick: anEvent [

	self behavior doubleClick: anEvent
]

{ #category : #'as yet unclassified' }
SBStName >> fixActions [

	^ self behavior fixActions
]

{ #category : #'as yet unclassified' }
SBStName >> guessedClass [

	^ self behavior guessedClass
]

{ #category : #'as yet unclassified' }
SBStName >> handleDroppedBlock: aBlock event: anEvent adding: aBoolean near: aMorph [

	(self behavior handleDroppedBlock: aBlock event: anEvent adding: aBoolean near: aMorph)
		ifFalse: [super handleDroppedBlock: aBlock event: anEvent adding: aBoolean near: aMorph]
]

{ #category : #'as yet unclassified' }
SBStName >> initialize [

	super initialize.
	
	self behavior: SBStBinding new.
	
	autoCast := true
]

{ #category : #'as yet unclassified' }
SBStName >> inputCommandClass [

	^ self behavior inputCommandClass
]

{ #category : #'as yet unclassified' }
SBStName >> isBinding [

	^ self behavior isBinding
]

{ #category : #'as yet unclassified' }
SBStName >> isBlockBinding [

	^ self behavior isBlockBinding
]

{ #category : #'as yet unclassified' }
SBStName >> isDeclaration [

	^ self behavior isDeclaration
]

{ #category : #'as yet unclassified' }
SBStName >> isExpression [

	^ self behavior isExpression
]

{ #category : #'as yet unclassified' }
SBStName >> isLiteralBlock [

	^ self behavior isLiteralBlock
]

{ #category : #'as yet unclassified' }
SBStName >> isMethodArgument [

	^ self behavior isMethodArgument
]

{ #category : #'as yet unclassified' }
SBStName >> isMethodLocal [

	^ self behavior isMethodLocal
]

{ #category : #'as yet unclassified' }
SBStName >> isName [

	^ true
]

{ #category : #'as yet unclassified' }
SBStName >> isReserved [

	^ ClassBuilder new reservedNames includes: self contents
]

{ #category : #'as yet unclassified' }
SBStName >> isTemporaryVariable [

	^ self behavior isTemporaryVariable
]

{ #category : #'as yet unclassified' }
SBStName >> keyStroke: anEvent [

	(self isExpression and: [anEvent keyCharacter = $:]) ifTrue: [ | new |
		new := self newNullBlock.
		^ self sandblockEditor
			endInput;
			do: ((SBWrapCommand newFor: self containingArtefact)
				inner: self;
				outer: SBStAssignment new;
				wrap: [:outer :inner | outer binding: self value: new]);
			startInput: new at: 0 replacingContents: false].
	
	super keyStroke: anEvent.
	
	self updateSuggestions
]

{ #category : #'as yet unclassified' }
SBStName >> lowercaseSuggestions [

	^ Array streamContents: [:str |
		self containingArtefact declarations select: [:v | v contents sandblockMatch: self contents] thenDo: [:v | str nextPut: v asSuggestionItem].
		self containingBlocksDo: [:block |
			(block temporaries select: [:v | v contents sandblockMatch: self contents] thenDo: [:v | str nextPut: v asSuggestionItem]).
			(block bindings select: [:v | v contents sandblockMatch: self contents] thenCollect: [:v | str nextPut: v asSuggestionItem])]]
]

{ #category : #'as yet unclassified' }
SBStName >> name: aString [

	self contents: aString
]

{ #category : #'as yet unclassified' }
SBStName >> noValidBinding [

	^ self behavior noValidBinding
]

{ #category : #'as yet unclassified' }
SBStName >> noteNewOwner: aMorph [

	(aMorph isNil or: [self autoCast isNil or: [self autoCast not]]) ifTrue: [^ self].
	
	((aMorph parentSandblock ifNotNil: #isMethod ifNil: [false]) and: [aMorph parentSandblock isMyArgument: self]) ifTrue: [^ self behavior: SBStDeclarationForMethodArgument new].
	aMorph isTemporaries ifTrue: [^ self behavior: SBStDeclarationForTemporaryVariable new].
	aMorph isBlockBindings ifTrue: [^ self behavior: SBStDeclarationForBlock new].
	(self containingArtefact ifNotNil: #isClassContainer ifNil: [false]) ifTrue: [
		aMorph = self containingArtefact instanceVariables ifTrue: [^ self behavior: SBStDeclarationForInstanceVariable new].
		aMorph = self containingArtefact classVariables ifTrue: [^ self behavior: SBStDeclarationForPoolVariable new]].
	
	((self containingArtefact ifNotNil: #isRepl ifNil: [false]) and: [aMorph = self containingArtefact localVariables])
		ifTrue: [^ self behavior: SBStDeclarationForLocalVariable new].
	
	(self contents = 'true' or: [self contents = 'false']) ifTrue: [^ self behavior: SBStBoolean new].
	self isReserved ifTrue: [^ self behavior: SBStKeywordBinding new].
	self flag: #fixme. " this may be too strict "
	
	aMorph isAssignment ifTrue: [^ self behavior: (self isFirstChild ifTrue: [SBStAssignmentLabel new] ifFalse: [SBStBinding new])].
	self behavior: SBStBinding new
]

{ #category : #'as yet unclassified' }
SBStName >> printOn: aStream [

	self behavior printBlockOn: aStream
]

{ #category : #'as yet unclassified' }
SBStName >> replaceWithUnknown [

	self behavior isExpression
		ifTrue: [super replaceWithUnknown]
]

{ #category : #'as yet unclassified' }
SBStName >> resolveBinding [

	^ self behavior resolveBinding
]

{ #category : #'as yet unclassified' }
SBStName >> symbols [

	^ self behavior symbolsFor: self colorPolicy
]

{ #category : #'as yet unclassified' }
SBStName >> textContents [

	^ self contents
]

{ #category : #'as yet unclassified' }
SBStName >> updateSuggestions [

	| suggestions |
	suggestions := self contents
		ifEmpty: [#()]
		ifNotEmpty: [:text |
			text first isUppercase
				ifTrue: [self uppercaseSuggestions]
				ifFalse: [self lowercaseSuggestions]].
	self updateSuggestions: suggestions showNear: self
]

{ #category : #'as yet unclassified' }
SBStName >> uppercaseSuggestions [

	self flag: #todo. "pool dict etc"
	^ Array streamContents: [:stream |
		Smalltalk globals keysAndValuesDo: [:key :value |
			(key sandblockMatch: self contents) ifTrue: [
				stream nextPut: (SBSuggestionItem
					selector: key
					label: ((value isBehavior and: [key == value name]) ifTrue: ['class'] ifFalse: ['global']))]].
		SBStSubstitution allSubclassesDo: [:class |
			(class name sandblockMatch: self contents) ifTrue: [
				class suggestion ifNotNil: [:block |
					stream nextPut: ((SBSuggestionItem selector: class name label: 'projection') completionAction: block)]]]]
]

{ #category : #'as yet unclassified' }
SBStName >> valid [

	^ self validContents and: [self behavior valid]
]

{ #category : #'as yet unclassified' }
SBStName >> validContents [

	^ self contents notEmpty
		and: [self contents first isLetter]
		and: [self contents from: 1 to: self contents size do: [:c | (c isAlphaNumeric or: [c = $_]) ifFalse: [^ false]]. true]
]

{ #category : #'as yet unclassified' }
SBStName >> veryDeepCopyWith: aCopier [

	| new previousBinding |
	previousBinding := binding.
	new := super veryDeepCopyWith: aCopier.
	binding := previousBinding.
	new binding: previousBinding.
	^ new
]

{ #category : #'as yet unclassified' }
SBStName >> wasDeselected [

	self flag: #todo. " will not clean up on changed usages "
	self isInWorld ifTrue: [
		self allUsagesDo: [:b | b detachDecorators: SBHighlightDecorator]]
]

{ #category : #'as yet unclassified' }
SBStName >> wasSelected [

	self allUsagesDo: [:b | b attachDecorator: SBHighlightDecorator new]
]

{ #category : #'as yet unclassified' }
SBStName >> writeSourceOn: aStream [

	aStream nextPutAll: text contents
]
