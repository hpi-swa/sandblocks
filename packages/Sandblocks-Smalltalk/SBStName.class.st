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
SBStName class >> classVariable: aString class: aClass [

	^ (self contents: aString)
		behavior: (SBStDeclarationForClassVariable new class: aClass);
		yourself
]

{ #category : #'as yet unclassified' }
SBStName class >> contents: aString [

	^ self new contents: aString; yourself
]

{ #category : #'as yet unclassified' }
SBStName class >> instanceVariable: aString class: aClass [

	^ (self contents: aString)
		behavior: (SBStDeclarationForInstanceVariable new class: aClass);
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

	^ self poolDeclaration: aString binding: nil
]

{ #category : #'as yet unclassified' }
SBStName class >> poolDeclaration: aString binding: aBinding [

	^ (self contents: aString)
		behavior: (SBStDeclarationForPoolVariable new binding: aBinding);
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
SBStName >> actionProviders [

	^ {self behavior}, super actionProviders
]

{ #category : #'as yet unclassified' }
SBStName >> allUsagesDo: aBlock [

	^ self behavior resolveBinding ifNotNil: [:binding | binding behavior allUsagesDo: aBlock]
]

{ #category : #converting }
SBStName >> asBinding: converter [
	<convert>
	
	converter do: [SBStName new contents: self contents; behavior: SBStBinding new; yourself]
]

{ #category : #converting }
SBStName >> asSchemeIdentifier: converter [
	<convert>
	
	converter do: [SBScmIdentifier new contents: self contents]
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
		anObject attached: self.
		self clearCache]
]

{ #category : #'as yet unclassified' }
SBStName >> behaviorClass: aClass [

	behavior class ~= aClass ifTrue: [
		behavior := aClass new.
		behavior attached: self]
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

	^ self behavior castToUnknownWhenEmpty
]

{ #category : #'as yet unclassified' }
SBStName >> clearCacheSelf [

	super clearCacheSelf.
	
	(self owner isNil or: [self autoCast isNil or: [self autoCast isBoolean and: [self autoCast not]]]) ifTrue: [^ self].
	
	(self autoCast notNil and: [self autoCast isBlock]) ifTrue: [^ self autoCast value: self value: self owner].
	
	SBStNameBehavior allSubclassesDo: [:cls | (cls checkCastFor: self parent: self owner) ifTrue: [^ self behaviorClass: cls]].
	
	self behaviorClass: SBStBinding
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
			do: (SBWrapCommand new
				inner: self;
				outer: SBStMessageSend new;
				wrap: [:outer :inner | outer binding: self value: new]);
			startInput: new at: 0 replacingContents: false].
	
	super keyStroke: anEvent
]

{ #category : #'as yet unclassified' }
SBStName >> lookupAction: aSymbol [

	(self behavior class lookupSelector: aSymbol) ifNotNil: [:m | (self isValidAction: m) ifTrue: [^ self behavior]].
	
	^ super lookupAction: aSymbol
]

{ #category : #'as yet unclassified' }
SBStName >> name: aString [

	self contents: aString
]

{ #category : #'as yet unclassified' }
SBStName >> noValidBinding [

	^ self behavior noValidBinding
]

{ #category : #'colors and color policies' }
SBStName >> preferredColorIn: aColorPolicy [

	self isReserved ifTrue: [^ aColorPolicy keyword].
	^ aColorPolicy identifier
]

{ #category : #'as yet unclassified' }
SBStName >> printOn: aStream [

	self behavior printBlockOn: aStream
]

{ #category : #'as yet unclassified' }
SBStName >> resolveBinding [

	^ self behavior resolveBinding
]

{ #category : #'as yet unclassified' }
SBStName >> suggestions [

	super suggestions ifNotEmpty: [:s | ^ s].
	^ self behavior suggestions
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

{ #category : #testing }
SBStName >> wantsInput [

	^ self contents isEmpty
]

{ #category : #'as yet unclassified' }
SBStName >> wasDeselected [

	self flag: #todo.
	" will not clean up on changed usages "
	self behavior wasDeselected.
	self isInWorld ifTrue: [
		self allUsagesDo: [:b | b detachDecorators: SBHighlightDecorator].
		self resolveBinding ifNotNil: [:b | b detachDecorators: SBHighlightDecorator]]
]

{ #category : #'as yet unclassified' }
SBStName >> wasSelected [

	self allUsagesDo: [:b | b attachDecorator: SBHighlightDecorator new].
	self behavior wasSelected.
	self resolveBinding ifNotNil: [:b | b attachDecorator: SBHighlightDecorator new].
	super wasSelected
]

{ #category : #'as yet unclassified' }
SBStName >> writeSourceOn: aStream [

	self behavior writeSourceOn: aStream
]
