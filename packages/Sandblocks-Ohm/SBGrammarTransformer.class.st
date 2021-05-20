Class {
	#name : #SBGrammarTransformer,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBGrammarTransformer class >> grammar: anOhmGrammar steps: aCollection [

	^ self new grammar: anOhmGrammar steps: aCollection
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> canDeleteChild: aBlock [

	^ aBlock isFirstChild not
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> grammar: aGrammar steps: aCollection [

	self childSandblocks first replaceBy: (SBOhmGrammar from: aGrammar grammarDefinitionString).
	self childSandblocks allButFirst do: #delete.
	aCollection do: [:block | self addMorphBack: (SBGrammarTransformStep new block: block asSandblock)]
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

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> saveTryFixing: aFixBoolean quick: aQuickBoolean [

	| source |
	source := String streamContents: [:stream |
		stream nextPutAll: 'restore ^'.
		stream nextPutAll: self className.
		stream space.
		stream nextPutAll: 'grammar: '.
		self childSandblocks first writeStSourceOn: stream.
		stream nextPutAll: ' steps: {'.
		self childSandblocks viewAllButFirst do: [:step | step block body writeSourceOn: stream].
		stream nextPutAll: '}'].
	self class class
		compile: (PPFormatter formatString: source class: nil class noPattern: false)
		classified: '*generated'.
	^ true
]
