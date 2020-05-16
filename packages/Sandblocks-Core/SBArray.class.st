Class {
	#name : #SBArray,
	#superclass : #SBASTNode,
	#instVars : [
		'type'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBArray class >> withContents: aCollection [

	| array |
	array := self new.
	aCollection do: [:m | array addMorphBack: m].
	^ array
]

{ #category : #converting }
SBArray >> acceptChild: aMorph [

	^ aMorph isExpression
]

{ #category : #converting }
SBArray >> addType [

	^ SBUnknown
]

{ #category : #'as yet unclassified' }
SBArray >> canDeleteChild: aBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBArray >> changeTypeTo: aSymbol [

	self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingArtefact)
		target: self;
		selector: #type;
		value: aSymbol)
]

{ #category : #converting }
SBArray >> childSandblocksDo: aBlock [

	self submorphsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBArray >> codeActions [

	^ super codeActions, {
		SBCodeAction
			labeled: 'Change to dynamic array' for: self do: [:node | node changeTypeTo: #dynamic].
		SBCodeAction
			labeled: 'Change to byte array' for: self do: [:node | node changeTypeTo: #byte].
		SBCodeAction
			labeled: 'Change to literal array' for: self do: [:node | node changeTypeTo: #literal].
	}
]

{ #category : #'as yet unclassified' }
SBArray >> contents: aCollection [

	self removeAllMorphs.
	aCollection do: [:m |
		self addMorphBack: m]
]

{ #category : #converting }
SBArray >> do: aBlock [

	self submorphs do: aBlock
]

{ #category : #'as yet unclassified' }
SBArray >> initialize [

	super initialize.
	
	type := #dynamic.
	
	self
		layoutPolicy: SBArrayLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		cellGap: 4 withScalingFactor;
		listDirection: #leftToRight;
		extent: self minExtent
]

{ #category : #'as yet unclassified' }
SBArray >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		index: (self childSandblocks indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
		container: self;
		morph: self addType new;
		shouldMergeWithNext: true;
		yourself
]

{ #category : #converting }
SBArray >> isArrayBlock [

	^ true
]

{ #category : #converting }
SBArray >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBArray >> isLiteralBlock [

	^ type = #literal
]

{ #category : #'as yet unclassified' }
SBArray >> minExtent [

	| inset |
	inset := self layoutInset.
	^ super minExtent max: inset left + inset right @ (self fontToUse height + inset top + inset bottom)
]

{ #category : #'as yet unclassified' }
SBArray >> prefix [

	^ type caseOf: {[#dynamic] -> ['{}']. [#literal] -> ['#()']. [#byte] -> ['#[]']} otherwise: '?'
]

{ #category : #converting }
SBArray >> printOn: aStream [

	aStream nextPutAll: 'array of length '.
	aStream nextPutAll: self submorphCount asString
]

{ #category : #'as yet unclassified' }
SBArray >> spaceForPrefix [

	^ super spaceForPrefix + (8 * self scalingFactor)
]

{ #category : #'as yet unclassified' }
SBArray >> type [

	^ type
]

{ #category : #'as yet unclassified' }
SBArray >> type: aSymbol [

	type := aSymbol.
	self changed; layoutChanged
]

{ #category : #'as yet unclassified' }
SBArray >> type: aSymbol contents: aCollection [

	type := aSymbol.
	
	self contents: aCollection
]

{ #category : #converting }
SBArray >> valid [

	type = #literal ifFalse: [^ true].
	
	self childSandblocksDo: [:b | b isLiteralBlock ifFalse: [^ false]].
	^ true
]

{ #category : #converting }
SBArray >> writeSourceOn: aStream [

	| prefix suffix |
	prefix := type caseOf: {[#dynamic] -> ['{']. [#literal] -> ['#(']. [#byte] -> ['#[']}.
	suffix := type caseOf: {[#dynamic] -> ['}']. [#literal] -> [')']. [#byte] -> [']']}.
	
	aStream nextPutAll: prefix.
	self submorphs
		do: [:m | m writeSourceOn: aStream]
		separatedBy: [type = #dynamic ifTrue: [aStream nextPutAll: '. '] ifFalse: [aStream space]].
	aStream nextPutAll: suffix
]