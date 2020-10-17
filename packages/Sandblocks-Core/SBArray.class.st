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

{ #category : #'as yet unclassified' }
SBArray >> changeTypeToByte [
	<action>

	self changeTypeTo: #byte
]

{ #category : #'as yet unclassified' }
SBArray >> changeTypeToDynamic [
	<action>
	
	self changeTypeTo: #dynamic
]

{ #category : #'as yet unclassified' }
SBArray >> changeTypeToLiteral [
	<action>
	
	self changeTypeTo: #literal
]

{ #category : #converting }
SBArray >> childSandblocksDo: aBlock [

	self submorphsDo: aBlock
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
SBArray >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBArray >> initialize [

	super initialize.
	
	type := #dynamic.
	
	self
		layoutPolicy: (SBAdaptiveLayout new wrap: true);
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
		morph: self newChild;
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

{ #category : #converting }
SBArray >> newChild [

	^ SBUnknown new
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
SBArray >> symbols [

	^ type
		caseOf: {
			([#dynamic] -> [self colorPolicy symbolsForArray: self]).
			([#literal] -> [self colorPolicy symbolsForLiteralArray: self]).
			([#byte] -> [self colorPolicy symbolsForByteArray: self])
		}
		otherwise: '?'
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
