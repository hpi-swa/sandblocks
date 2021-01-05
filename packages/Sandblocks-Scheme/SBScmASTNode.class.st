Class {
	#name : #SBScmASTNode,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmASTNode >> contextAcceptedRepresentationAt: aNumber [

	^ #isScmExpression
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
	
	self wrapAsArgument
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
	
	self sandblockEditor
		do: ((SBWrapCommand newFor: self containingArtefact)
			outer: SBScmExpression new;
			inner: self;
			wrap: [:outer :inner | outer addMorphBack: inner])
]
