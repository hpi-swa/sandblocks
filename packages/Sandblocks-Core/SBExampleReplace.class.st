Class {
	#name : #SBExampleReplace,
	#superclass : #SBSubstitution,
	#category : 'Sandblocks-Core'
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

	^ [:block | block sandblockEditor do: ((SBReplaceCommand newFor: block containingArtefact)
		target: block;
		replacer: (SBExampleReplace new replace: SBBlockBody empty with: SBBlockBody empty))]
]

{ #category : #'as yet unclassified' }
SBExampleReplace >> childSandblocksDo: aBlock [

	aBlock value: self submorphs first submorphs second.
	aBlock value: self submorphs second submorphs second
]

{ #category : #'as yet unclassified' }
SBExampleReplace >> drawnColor [

	^ Color veryDarkGray
]

{ #category : #'as yet unclassified' }
SBExampleReplace >> initialize [

	super initialize.
	self
		 layoutPolicy: SBVerticalLayout new;
		 layoutInset: 6 withScalingFactor;
		 cellGap: 8 withScalingFactor;
		 hResizing: #shrinkWrap;
		 vResizing: #shrinkWrap;
		 addMorphBack: (SBRow new cellGap: 8 withScalingFactor; addMorphBack: (SBStringMorph new contents: 'Original:'));
		 addMorphBack: (SBRow new cellGap: 8 withScalingFactor; addMorphBack: (SBStringMorph new contents: 'Replace:'))
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
