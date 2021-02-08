Class {
	#name : #SBScmASTNode,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmASTNode >> canEvaluate [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> changeToUnknown [
	<action>

	self newNullBlock
		convertedFor: self objectInterface
		do: [:new |
			new ifNotNil: [
				self sandblockEditor
					copyBuffer: self;
					do: ((SBReplaceCommand newFor: self containingArtefact)
						target: self;
						replacer: new;
						shouldMergeWithNext: true;
						yourself);
					startInput: new at: 0 replacingContents: false]]
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> containingStatement [

	| parent |
	parent := self parentSandblock.
	parent ifNil: [^ nil].
	
	parent withStatementsDo: [:s | (s includes: self) ifTrue: [^ self]] ifNotApplicable: [].
	^ parent containingStatement
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> contextAcceptedRepresentationAt: aNumber [

	^ #isScmExpression
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> copyString [
	<action>
	
	Clipboard clipboardText: self sourceString
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> evaluate [

	^ QoppaInterpreter new readAndEvaluate: self sourceString
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> initialize [

	super initialize.
		
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutPolicy: SBAlgebraLayout new
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> insertStatementAbove [
	<action>

	self insertStatementAboveOrBelow: true
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> insertStatementAboveOrBelow: anAboveBoolean [

	| currentStatement index newStatement |
	newStatement := self newNullBlock.
	currentStatement := self containingStatement.
	
	index := currentStatement owner submorphIndexOf: currentStatement.
	self sandblockEditor do: ((SBInsertCommand newFor: self containingArtefact)
		index: (anAboveBoolean ifTrue: [index] ifFalse: [index + 1]);
		container: currentStatement owner;
		morph: newStatement;
		shouldMergeWithNext: true;
		yourself).
	self sandblockEditor startInput: newStatement at: 1 replacingContents: false
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> insertStatementBelow [
	<action>

	self insertStatementAboveOrBelow: false
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> isIdentifier [

	^ false
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> isSExpr [

	^ false
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> isScmExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> leftRotate [
	<action>
	<inputAction>
	
	self sandblockEditor
		do: ((SBWrapCommand newFor: self containingArtefact)
			outer: SBScmExpression new;
			inner: self;
			wrap: [:outer :inner | outer addMorphBack: inner])
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> newNullBlock [

	^ SBUnknown new grammarHandler: SBScmGrammarHandler new
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> object [

	^ self
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> sourceString [

	^ String streamContents: [:s | self writeSourceOn: s]
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> wrapAsArgument [
	<action>
	
	self insertElementBefore
]

{ #category : #'as yet unclassified' }
SBScmASTNode >> wrapInMessageSend [
	<action>	
	<actionValidIf: #isScmExpression>
	
	self insertElementAfter
]
