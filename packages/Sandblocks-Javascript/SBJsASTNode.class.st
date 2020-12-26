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
SBJsASTNode >> contextAcceptedRepresentationAt: aNumber [

	^ #isJsExpression
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
	index := currentStatement owner submorphs indexOf: currentStatement.
	self sandblockEditor do: ((SBInsertCommand newFor: self containingArtefact)
		index: (anAboveBoolean ifTrue: [index] ifFalse: [index + 1]);
		container: currentStatement owner;
		morph: newStatement;
		shouldMergeWithNext: true;
		yourself).
	self sandblockEditor startInput: newStatement at: 1 replacingContents: false
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
SBJsASTNode >> wrapInReturn [
	<action>
	<actionValidIf: #isStatement>
	
	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
		outer: SBJsReturn new;
		inner: self;
		wrap: [:outer :inner | outer expression: inner])
]
