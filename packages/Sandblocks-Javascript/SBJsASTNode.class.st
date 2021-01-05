Class {
	#name : #SBJsASTNode,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsASTNode >> centerAlignSymbols [

	^ false
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> changeToUnknown [
	<action>

	| new |
	new := self newNullBlock anyRepresentationThat: self acceptedRepresentation.
	new ifNotNil: [
		self sandblockEditor
			copyBuffer: self;
			do: ((SBReplaceCommand newFor: self containingArtefact)
				target: self;
				replacer: new;
				shouldMergeWithNext: true;
				yourself);
			startInput: new at: 0 replacingContents: false]
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> contextAcceptedRepresentationAt: aNumber [

	^ #isJsExpression
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> copyString [
	<action>

	Clipboard clipboardText: self sourceString
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> initialize [

	super initialize.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutPolicy: SBAlgebraLayout new
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> insertStatementAbove [
	<action>

	self insertStatementAboveOrBelow: true
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> insertStatementAboveOrBelow: anAboveBoolean [

	| currentStatement index newStatement |
	newStatement := self newNullBlock.
	currentStatement := self containingStatement ifNil: [^ self containingArtefact insertStatementAboveOrBelow: anAboveBoolean].
	
	(anAboveBoolean not and: [self containingBlock = currentStatement or: [self containingBlock hasOwner: currentStatement]]) ifTrue: [
		^ self sandblockEditor
			do: ((SBInsertCommand newFor: self containingArtefact)
				index: self containingBlock statementsIndex;
				container: self containingBlock;
				morph: newStatement;
				shouldMergeWithNext: true;
				yourself);
			startInput: newStatement at: 1 replacingContents: false].
	
	index := currentStatement owner submorphIndexOf: currentStatement.
	self sandblockEditor
		do: ((SBInsertCommand newFor: self containingArtefact)
			index: (anAboveBoolean ifTrue: [index] ifFalse: [index + 1]);
			container: currentStatement owner;
			morph: newStatement;
			shouldMergeWithNext: true;
			yourself);
		startInput: newStatement at: 1 replacingContents: false
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> insertStatementBelow [
	<action>
	<actionValidIf: #hasNoSuggestions>

	self insertStatementAboveOrBelow: false
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> isBinaryOperator [

	^ false
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> isClosure [

	^ false
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> isExpression [

	^ false
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> isJsExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> isStatement [

	^ self owner isBlockBody
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> newNullBlock [

	^ SBUnknown new grammarHandler: SBJsGrammarHandler new
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> object [

	^ self
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> sourceString [

	^ String streamContents: [:s | self writeSourceOn: s]
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> wrapAsArgument [
	<action>
	<actionValidIf: #isJsExpression>

	| operator |
	self flag: #todo. " figure out a way to make the terminology language dependent: the shortcut comes from Smalltalk "
	operator := SBJsPrefixOperator new.
	self sandblockEditor
		do: ((SBWrapCommand newFor: self containingArtefact)
			inner: self;
			outer: operator;
			wrap: [:outer :inner | outer operator: '' rhs: inner]);
		startInput: operator at: 0 replacingContents: false
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> wrapInDynamicArray [
	<action>
	<actionValidIf: #isExpression>
	
	| key |
	self flag: #todo. " figure out a way to make the terminology language dependent: the shortcut comes from Smalltalk where { is an array but in JS it's an object "
	key := self newNullBlock.
	self sandblockEditor
		do: ((SBWrapCommand newFor: self containingArtefact)
			inner: self;
			outer: SBJsObjectLiteral new;
			wrap: [:outer :inner | outer pairs: {key -> inner}]);
		startInput: key at: 0 replacingContents: false
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> wrapInMessageSend [
	<action>
	<actionValidIf: #isExpression>
	
	| operator |
	self flag: #todo. " figure out a way to make the terminology language dependent: the shortcut comes from Smalltalk "
	operator := SBJsInfixOperator new.
	self sandblockEditor
		do: ((SBWrapCommand newFor: self containingArtefact)
			inner: self;
			outer: operator;
			wrap: [:outer :inner | outer lhs: inner operator: '' rhs: operator newNullBlock]);
		startInput: operator at: 0 replacingContents: false
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> wrapInReturn [
	<action>
	<actionValidIf: #isStatement>
	
	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
		outer: SBJsReturn new;
		inner: self;
		wrap: [:outer :inner | outer expression: inner])
]

{ #category : #'as yet unclassified' }
SBJsASTNode >> writeSourceOn: aStream [

	self subclassResponsibility
]
