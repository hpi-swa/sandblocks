Class {
	#name : #SBStArray,
	#superclass : #SBStASTNode,
	#instVars : [
		'type'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStArray class >> withContents: aCollection [

	| array |
	array := self new.
	aCollection do: [:m | array addMorphBack: m].
	^ array
]

{ #category : #'as yet unclassified' }
SBStArray >> canDeleteChild: aBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBStArray >> changeTypeTo: aSymbol [

	self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingArtefact)
		target: self;
		selector: #type;
		value: aSymbol)
]

{ #category : #'as yet unclassified' }
SBStArray >> changeTypeToByte [
	<action>

	self changeTypeTo: #byte
]

{ #category : #'as yet unclassified' }
SBStArray >> changeTypeToDynamic [
	<action>
	
	self changeTypeTo: #dynamic
]

{ #category : #'as yet unclassified' }
SBStArray >> changeTypeToLiteral [
	<action>
	
	self changeTypeTo: #literal
]

{ #category : #'as yet unclassified' }
SBStArray >> contents: aCollection [

	self removeAllMorphs.
	aCollection do: [:m |
		self addMorphBack: m]
]

{ #category : #converting }
SBStArray >> do: aBlock [

	self submorphs do: aBlock
]

{ #category : #'as yet unclassified' }
SBStArray >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBStArray >> initialize [

	super initialize.
	
	type := #dynamic.
	
	self
		cellGap: 4 withScalingFactor;
		extent: self minExtent
]

{ #category : #'as yet unclassified' }
SBStArray >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		index: (self childSandblocks indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
		container: self;
		morph: self newChild;
		shouldMergeWithNext: true;
		yourself
]

{ #category : #converting }
SBStArray >> isArrayBlock [

	^ true
]

{ #category : #converting }
SBStArray >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBStArray >> isLiteralBlock [

	^ type = #literal
]

{ #category : #converting }
SBStArray >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand softLineOrGap withGap: true])
]

{ #category : #'as yet unclassified' }
SBStArray >> minExtent [

	| inset |
	inset := self layoutInset.
	^ super minExtent max: inset left + inset right @ (self fontToUse height + inset top + inset bottom)
]

{ #category : #'as yet unclassified' }
SBStArray >> minimumHeight [

	| inset |
	inset := self layoutInset.
	^ (self fontToUse height + inset top + inset bottom)
]

{ #category : #converting }
SBStArray >> newChild [

	^ self newNullBlock
]

{ #category : #'as yet unclassified' }
SBStArray >> prefix [

	^ type caseOf: {[#dynamic] -> ['{}']. [#literal] -> ['#()']. [#byte] -> ['#[]']} otherwise: '?'
]

{ #category : #converting }
SBStArray >> printOn: aStream [

	aStream nextPutAll: 'array of length '.
	aStream nextPutAll: self submorphCount asString
]

{ #category : #'as yet unclassified' }
SBStArray >> symbols [

	^ type
		caseOf: {
			([#dynamic] -> [self colorPolicy symbolsForArray: self]).
			([#literal] -> [self colorPolicy symbolsForLiteralArray: self]).
			([#byte] -> [self colorPolicy symbolsForByteArray: self])
		}
		otherwise: '?'
]

{ #category : #'as yet unclassified' }
SBStArray >> type [

	^ type
]

{ #category : #'as yet unclassified' }
SBStArray >> type: aSymbol [

	type := aSymbol.
	self changed; layoutChanged
]

{ #category : #'as yet unclassified' }
SBStArray >> type: aSymbol contents: aCollection [

	type := aSymbol.
	
	self contents: aCollection
]

{ #category : #converting }
SBStArray >> valid [

	type = #literal ifFalse: [^ true].
	
	self childSandblocksDo: [:b | b isLiteralBlock ifFalse: [^ false]].
	^ true
]

{ #category : #converting }
SBStArray >> writeSourceOn: aStream [

	| prefix suffix |
	prefix := type caseOf: {[#dynamic] -> ['{']. [#literal] -> ['#(']. [#byte] -> ['#[']}.
	suffix := type caseOf: {[#dynamic] -> ['}']. [#literal] -> [')']. [#byte] -> [']']}.
	
	aStream nextPutAll: prefix.
	self submorphs
		do: [:m | m writeSourceOn: aStream]
		separatedBy: [type = #dynamic ifTrue: [aStream nextPutAll: '. '] ifFalse: [aStream space]].
	aStream nextPutAll: suffix
]
