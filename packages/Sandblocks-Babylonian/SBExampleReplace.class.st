Class {
	#name : #SBExampleReplace,
	#superclass : #SBStSubstitution,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'as yet unclassified' }
SBExampleReplace class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].

	^ aBlock isConstructor: 'replace:with:' for: self
]

{ #category : #'as yet unclassified' }
SBExampleReplace class >> newFor: aBlock [

	^ self new replace: aBlock arguments first with: aBlock arguments second
]

{ #category : #'as yet unclassified' }
SBExampleReplace class >> replace: aBlock with: anotherBlock [

	SBExample allInstancesDo: [:example |
		example isCurrent ifTrue: [^ anotherBlock value]].
	
	^ aBlock value
]

{ #category : #'as yet unclassified' }
SBExampleReplace class >> suggestion [

	^ [:block |
		block sandblockEditor do: (SBReplaceCommand new
			target: block;
			replacer: (SBExampleReplace new replace: SBStBlockBody empty with: SBStBlockBody empty))]
]

{ #category : #'as yet unclassified' }
SBExampleReplace >> drawnColor [

	^ self colorPolicy toolColorFor: self
]

{ #category : #'as yet unclassified' }
SBExampleReplace >> initialize [

	super initialize.
	self
		layoutPolicy: SBVerticalLayout new;
		layoutInset: 6;
		cellGap: 8;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (SBRow new
			cellGap: 8;
			addMorphBack: (SBStringMorph new contents: 'Original:'));
		addMorphBack: (SBRow new
			cellGap: 8;
			addMorphBack: (SBStringMorph new contents: 'Replace:'))
]

{ #category : #'as yet unclassified' }
SBExampleReplace >> replace: aBlock with: anotherBlock [

	self submorphs first addMorphBack: aBlock.
	self submorphs second addMorphBack: anotherBlock
]

{ #category : #'as yet unclassified' }
SBExampleReplace >> writeSourceOn: aStream [

	self constructorString: 'replace:with:' arguments: self childSandblocks on: aStream
]
