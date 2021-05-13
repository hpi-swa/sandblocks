Class {
	#name : #SBGrammarTransformer,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> canDeleteChild: aBlock [

	^ aBlock isFirstChild not
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> initialize [

	super initialize.
	self
		hResizing: #rigid;
		width: 200;
		vResizing: #shrinkWrap;
		changeTableLayout;
		listDirection: #topToBottom;
		addMorphBack: (SBStringMorph new contents: 'Input Grammar');
		addMorphBack: SBOhmGrammar new;
		addMorphBack: (SBStringMorph new contents: 'Transforms');
		addMorphBack: SBGrammarTransformStep new;
		attachDecorator: SBMoveDecorator new;
		attachDecorator: SBResizableDecorator new
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> newEmptyChildNear: aBlock before: aBoolean [

	^ SBGrammarTransformStep new
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> objectInterfaceNear: aBlock at: aSymbol [

	aBlock isFirstChild ifTrue: [
		^ aSymbol = #replace
			ifTrue: [{[:o | o isKindOf: SBOhmGrammar]}]
			ifFalse: [SBInterfaces never]].
	^ {[:o | o isKindOf: SBGrammarTransformStep]}
]
