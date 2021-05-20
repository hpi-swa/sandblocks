Class {
	#name : #SBGrammarTransformStep,
	#superclass : #SBBlock,
	#instVars : [
		'lastError'
	],
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBGrammarTransformStep >> artefactChanged: aMethodBlock [

	(aMethodBlock parentSandblock isKindOf: SBGrammarTransformStep) ifTrue: [ | step |
		step := aMethodBlock parentSandblock.
		step rerun]
]

{ #category : #'as yet unclassified' }
SBGrammarTransformStep >> block [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBGrammarTransformStep >> block: aBlock [

	self block replaceBy: (SBStContainer new statements: {aBlock})
]

{ #category : #'as yet unclassified' }
SBGrammarTransformStep >> grammar [

	^ self lastSubmorph
]

{ #category : #'as yet unclassified' }
SBGrammarTransformStep >> initialize [

	super initialize.
	self
		hResizing: #spaceFill;
		vResizing: #shrinkWrap;
		changeTableLayout;
		listDirection: #leftToRight;
		addMorphBack: (SBStContainer new statements: {SBStBlockBody emptyWithDeclarations: {'g'}})
]

{ #category : #'as yet unclassified' }
SBGrammarTransformStep >> rerun [

	| previous inputGrammar block |
	previous := self adjacentBlock: -1.
	inputGrammar := ((previous isKindOf: SBOhmGrammar)
		ifTrue: [previous]
		ifFalse: [previous grammar]) veryDeepCopy.
	
	block := self firstSubmorph statements first.
	block validSubtree ifTrue: [
		[block evaluate value: inputGrammar] on: Error do: [:err |
			lastError ifNotNil: #delete.
			lastError := self sandblockEditor reportErrorWithProcessCopy: err].
		self submorphCount = 2 ifTrue: [self lastSubmorph delete].
		self addMorphBack: (inputGrammar hResizing: #spaceFill)]
]
