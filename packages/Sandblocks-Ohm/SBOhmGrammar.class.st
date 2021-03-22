Class {
	#name : #SBOhmGrammar,
	#superclass : #SBOhmASTNode,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBOhmGrammar >> canDeleteChild: aBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> initialize [

	super initialize.
	
	self
		layoutInset: 8;
		attachDecorator: SBResizableDecorator new;
		attachDecorator: SBMoveDecorator new
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		index: (self childSandblocks indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
		container: self;
		morph: (SBOhmRule new name: '' alternatives: self newNullBlock);
		shouldMergeWithNext: true;
		yourself
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> isBlockBody [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> layoutCommands [

	^ SBAlgebraCommand container
		data: (self submorphs
			collect: #layoutCommands
			separatedBy: [SBAlgebraCommand hardLine withGap: true]);
		morph: self
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> objectInterfaceAt: aNumber adding: aBoolean [

	^ {#isSandblock. #isOhm. [:o | o isExpression not]}
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> rules [

	^ self submorphs
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> sandblockBlockColorIfAbsent: aBlock [

	^ self preferredColor
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> statements [

	^ self rules
]
