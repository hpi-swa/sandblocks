Class {
	#name : #SBName,
	#superclass : #SBLiteral,
	#instVars : [
		'behavior',
		'binding',
		'autoCast'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBName class >> contents: aString [

	^ self new contents: aString; yourself
]

{ #category : #'as yet unclassified' }
SBName class >> instanceVariable: aString [

	^ (self contents: aString)
		behavior: SBDeclarationForInstanceVariable new;
		yourself
]

{ #category : #'as yet unclassified' }
SBName class >> newWith: aNameBehavior [

	^ self new
		behavior: aNameBehavior;
		yourself
]

{ #category : #'as yet unclassified' }
SBName class >> poolDeclaration: aString [

	^ (self contents: aString)
		behavior: SBDeclarationForPoolVariable new;
		yourself
]

{ #category : #'as yet unclassified' }
SBName >> acceptInputEvent: anEvent [

	| char |
	char := anEvent keyCharacter.
	(char isAlphaNumeric or: [char = $_])
		ifTrue: [super acceptInputEvent: anEvent]
		ifFalse: [
			self isExpression ifTrue: [SBSmalltalkGrammarHandler new perform: char for: self empty: false]]
]

{ #category : #'as yet unclassified' }
SBName >> actions [

	^ super actions, self behavior actions
]

{ #category : #'as yet unclassified' }
SBName >> allUsages [

	^ self behavior resolveBinding ifNotNil: [:binding | binding allUsages] ifNil: [#()]
]

{ #category : #'as yet unclassified' }
SBName >> asSuggestionItem [

	^ self behavior asSuggestionItem
]

{ #category : #accessing }
SBName >> autoCast [

	^ autoCast
]

{ #category : #accessing }
SBName >> autoCast: aBoolean [

	autoCast := aBoolean
]

{ #category : #'as yet unclassified' }
SBName >> behavior [

	^ behavior
]

{ #category : #'as yet unclassified' }
SBName >> behavior: anObject [

	behavior class ~= anObject class ifTrue: [
		behavior := anObject.
		anObject attached: self]
]

{ #category : #'as yet unclassified' }
SBName >> binding [

	^ binding
]

{ #category : #'as yet unclassified' }
SBName >> binding: aBinding [

	binding := aBinding
]

{ #category : #'as yet unclassified' }
SBName >> browse [

	^ self behavior browse
]

{ #category : #'as yet unclassified' }
SBName >> castToUnknownWhenEmpty [

	^ self isExpression
]

{ #category : #'as yet unclassified' }
SBName >> contentsChanged [

	self behavior contentsChanged.
	
	super contentsChanged
]

{ #category : #'as yet unclassified' }
SBName >> doubleClick: anEvent [

	self behavior doubleClick: anEvent
]

{ #category : #'as yet unclassified' }
SBName >> fixActions [

	^ self behavior fixActions
]

{ #category : #'as yet unclassified' }
SBName >> guessedClass [

	^ self behavior guessedClass
]

{ #category : #'as yet unclassified' }
SBName >> handleDroppedBlock: aBlock event: anEvent [

	(self behavior handleDroppedBlock: aBlock event: anEvent) ifFalse: [super handleDroppedBlock: aBlock event: anEvent]
]

{ #category : #'as yet unclassified' }
SBName >> initialize [

	super initialize.
	
	self behavior: SBBinding new.
	
	autoCast := true
]

{ #category : #'as yet unclassified' }
SBName >> inputCommandClass [

	^ self behavior inputCommandClass
]

{ #category : #'as yet unclassified' }
SBName >> isBinding [

	^ self behavior isBinding
]

{ #category : #'as yet unclassified' }
SBName >> isBlockBinding [

	^ self behavior isBlockBinding
]

{ #category : #'as yet unclassified' }
SBName >> isDeclaration [

	^ self behavior isDeclaration
]

{ #category : #'as yet unclassified' }
SBName >> isExpression [

	^ self behavior isExpression
]

{ #category : #'as yet unclassified' }
SBName >> isLiteralBlock [

	^ self behavior isLiteralBlock
]

{ #category : #'as yet unclassified' }
SBName >> isMethodArgument [

	^ self behavior isMethodArgument
]

{ #category : #'as yet unclassified' }
SBName >> isMethodLocal [

	^ self behavior isMethodLocal
]

{ #category : #'as yet unclassified' }
SBName >> isName [

	^ true
]

{ #category : #'as yet unclassified' }
SBName >> isReserved [

	^ ClassBuilder new reservedNames includes: self contents
]

{ #category : #'as yet unclassified' }
SBName >> isTemporaryVariable [

	^ self behavior isTemporaryVariable
]

{ #category : #'as yet unclassified' }
SBName >> keyStroke: anEvent [

	(self isExpression and: [anEvent keyCharacter = $:]) ifTrue: [ | new |
		new := SBUnknown new.
		^ self sandblockEditor
			endInput;
			do: ((SBWrapCommand newFor: self containingArtefact)
				inner: self;
				outer: SBAssignment new;
				wrap: [:outer :inner | outer binding: self value: new]);
			startInput: new at: 0 replacingContents: false].
	
	super keyStroke: anEvent.
	
	self updateSuggestions
]

{ #category : #'as yet unclassified' }
SBName >> lookupAction: aSymbol [

	^ (self behavior class lookupSelector: aSymbol) ifNil: [self class lookupSelector: aSymbol]
]

{ #category : #'as yet unclassified' }
SBName >> lowercaseSuggestions [

	^ Array streamContents: [:str |
		self containingArtefact declarations select: [:v | v contents sandblockMatch: self contents] thenDo: [:v | str nextPut: v asSuggestionItem].
		self containingBlocksDo: [:block |
			(block temporaries select: [:v | v contents sandblockMatch: self contents] thenDo: [:v | str nextPut: v asSuggestionItem]).
			(block bindings select: [:v | v contents sandblockMatch: self contents] thenCollect: [:v | str nextPut: v asSuggestionItem])]]
]

{ #category : #'as yet unclassified' }
SBName >> name: aString [

	self contents: aString
]

{ #category : #'as yet unclassified' }
SBName >> noValidBinding [

	^ self behavior noValidBinding
]

{ #category : #'as yet unclassified' }
SBName >> noteNewOwner: aMorph [

	(aMorph isNil or: [self autoCast isNil or: [self autoCast not]]) ifTrue: [^ self].
	
	((aMorph parentSandblock ifNotNil: #isMethod ifNil: [false]) and: [aMorph parentSandblock isMyArgument: self]) ifTrue: [^ self behavior: SBDeclarationForMethodArgument new].
	aMorph isTemporaries ifTrue: [^ self behavior: SBDeclarationForTemporaryVariable new].
	aMorph isBlockBindings ifTrue: [^ self behavior: SBDeclarationForBlock new].
	(self containingArtefact ifNotNil: #isClassContainer ifNil: [false]) ifTrue: [
		aMorph = self containingArtefact instanceVariables ifTrue: [^ self behavior: SBDeclarationForInstanceVariable new].
		aMorph = self containingArtefact classVariables ifTrue: [^ self behavior: SBDeclarationForPoolVariable new]].
	
	((self containingArtefact ifNotNil: #isRepl ifNil: [false]) and: [aMorph = self containingArtefact localVariables])
		ifTrue: [^ self behavior: SBDeclarationForLocalVariable new].
	
	(self contents = 'true' or: [self contents = 'false']) ifTrue: [^ self behavior: SBBoolean new].
	self isReserved ifTrue: [^ self behavior: SBKeywordBinding new].
	self flag: #fixme. " this may be too strict "
	
	aMorph isAssignment ifTrue: [^ self behavior: (self isFirstChild ifTrue: [SBAssignmentLabel new] ifFalse: [SBBinding new])].
	self behavior: SBBinding new
]

{ #category : #'as yet unclassified' }
SBName >> performAction: aSymbol [

	(self behavior respondsTo: aSymbol) ifTrue: [self behavior perform: aSymbol] ifFalse: [super performAction: aSymbol]
]

{ #category : #'as yet unclassified' }
SBName >> printOn: aStream [

	self behavior printBlockOn: aStream
]

{ #category : #'as yet unclassified' }
SBName >> replaceWithUnknown [

	self behavior isExpression
		ifTrue: [super replaceWithUnknown]
]

{ #category : #'as yet unclassified' }
SBName >> resolveBinding [

	^ self behavior resolveBinding
]

{ #category : #'as yet unclassified' }
SBName >> symbols [

	^ self behavior symbolsFor: self colorPolicy
]

{ #category : #'as yet unclassified' }
SBName >> textContents [

	^ self contents
]

{ #category : #'as yet unclassified' }
SBName >> updateSuggestions [

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
SBName >> uppercaseSuggestions [

	self flag: #todo. "pool dict etc"
	^ Array streamContents: [:stream |
		Smalltalk globals keysAndValuesDo: [:key :value |
			(key sandblockMatch: self contents) ifTrue: [
				stream nextPut: (SBSuggestionItem
					selector: key
					label: ((value isBehavior and: [key == value name]) ifTrue: ['class'] ifFalse: ['global']))]].
		SBSubstitution allSubclassesDo: [:class |
			(class name sandblockMatch: self contents) ifTrue: [
				class suggestion ifNotNil: [:block |
					stream nextPut: ((SBSuggestionItem selector: class name label: 'projection') completionAction: block)]]]]
]

{ #category : #'as yet unclassified' }
SBName >> valid [

	^ self validContents and: [self behavior valid]
]

{ #category : #'as yet unclassified' }
SBName >> validContents [

	^ self contents notEmpty
		and: [self contents first isLetter]
		and: [self contents from: 1 to: self contents size do: [:c | (c isAlphaNumeric or: [c = $_]) ifFalse: [^ false]]. true]
]

{ #category : #'as yet unclassified' }
SBName >> veryDeepCopyWith: aCopier [

	| new previousBinding |
	previousBinding := binding.
	new := super veryDeepCopyWith: aCopier.
	binding := previousBinding.
	new binding: previousBinding.
	^ new
]

{ #category : #'as yet unclassified' }
SBName >> wasDeselected [

	self flag: #todo. " will not clean up on changed usages "
	self isInWorld ifTrue: [
		self allUsages do: [:b | b detachDecorators: SBHighlightDecorator]]
]

{ #category : #'as yet unclassified' }
SBName >> wasSelected [

	self allUsages do: [:b | b attachDecorator: SBHighlightDecorator new]
]

{ #category : #'as yet unclassified' }
SBName >> writeSourceOn: aStream [

	aStream nextPutAll: text contents
]
