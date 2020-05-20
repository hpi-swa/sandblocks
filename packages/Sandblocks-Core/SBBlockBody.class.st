Class {
	#name : #SBBlockBody,
	#superclass : #SBASTNode,
	#instVars : [
		'temporaries',
		'bindings',
		'pc'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBBlockBody class >> empty [

	^ SBBlockBody new
		statements: {SBUnknown new};
		temporaries: {};
		bindings: {};
		yourself
]

{ #category : #'as yet unclassified' }
SBBlockBody class >> emptyWithDeclarations: aCollectionOfStrings [

	^ SBBlockBody new
		statements: {SBUnknown new};
		temporaries: {};
		bindings: (aCollectionOfStrings collect: [:s | SBName contents: s]);
		yourself
]

{ #category : #'as yet unclassified' }
SBBlockBody >> acceptChild: aMorph [

	^ true
]

{ #category : #converting }
SBBlockBody >> addBlockArgument [

	self sandblockEditor
		endInput;
		do: ((SBInsertCommand newFor: self containingArtefact)
			index: bindings submorphCount + 1;
			container: bindings;
			morph: SBName new;
			shouldMergeWithNext: true;
			yourself);
		startInput: self sandblockEditor selection at: 0 replacingContents: false
]

{ #category : #converting }
SBBlockBody >> bindingFor: aString class: aClass ifPresent: aBlock [

	temporaries submorphs detect: [:s | s contents = aString] ifFound: [:s | ^ aBlock value: s] ifNone: [].
	bindings submorphs detect: [:s | s contents = aString] ifFound: [:s | ^ aBlock value: s] ifNone: [].
	^ super bindingFor: aString class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBBlockBody >> bindings [

	^ bindings submorphs
]

{ #category : #'as yet unclassified' }
SBBlockBody >> bindings: aCollection [

	aCollection do: [:m | bindings addMorphBack: m]
]

{ #category : #'as yet unclassified' }
SBBlockBody >> canDeleteChild: aBlock [

	^ true
]

{ #category : #converting }
SBBlockBody >> childSandblocksDo: aBlock [

	bindings submorphsDo: aBlock.
	temporaries submorphsDo: aBlock.
	self submorphs allButFirstDo: aBlock
]

{ #category : #'as yet unclassified' }
SBBlockBody >> declareTemporaryVariable: aString [

	self sandblockEditor do: (self declareTemporaryVariableCommand: aString)
]

{ #category : #'as yet unclassified' }
SBBlockBody >> declareTemporaryVariableCommand: aString [

	^ (SBInsertCommand newFor: self containingArtefact)
		container: temporaries;
		index: temporaries submorphCount + 1;
		morph: (SBName contents: aString);
		yourself
]

{ #category : #'as yet unclassified' }
SBBlockBody >> evaluateWithArguments: aCollection [

	^ (Compiler evaluate: self sourceString) valueWithEnoughArguments: aCollection
]

{ #category : #'as yet unclassified' }
SBBlockBody >> guessedClass [

	^ BlockClosure
]

{ #category : #'as yet unclassified' }
SBBlockBody >> initialize [

	super initialize.
	
	bindings := SBBlockBindings new.
	temporaries := SBTemporaries new.
	pc := 0.
	
	self
		layoutPolicy: SBBlockBodyLayout new;
		color: Color random;
		cellPositioning: #topLeft;
		cellPositioning: #topLeft;
		listDirection: #topToBottom;
		vResizing: #shrinkWrap; hResizing: #shrinkWrap;
		addMorphBack: (SBRow new
			hideWhenEmpty: true;
			cellGap: 8 withScalingFactor;
			addMorphBack: bindings;
			addMorphBack: temporaries)
]

{ #category : #'as yet unclassified' }
SBBlockBody >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (aBlock notNil and: [aBlock isName and: [aBlock isBlockBinding and: [self isMethodBody not]]])
		ifTrue: [
			(SBInsertCommand newFor: self containingArtefact)
				index: (bindings submorphIndexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
				container: bindings;
				morph: SBName new;
				shouldMergeWithNext: true;
				yourself]
		ifFalse: [
			(SBInsertCommand newFor: self containingArtefact)
				index: (self childSandblocks indexOf: aBlock) + 1 + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
				container: self;
				morph: SBUnknown new;
				shouldMergeWithNext: true;
				yourself]
]

{ #category : #'as yet unclassified' }
SBBlockBody >> isBlockBody [

	^ true
]

{ #category : #converting }
SBBlockBody >> isExpression [

	^ self parentSandblock isMethod not
]

{ #category : #testing }
SBBlockBody >> isMethodBody [

	^ self owner notNil and: [self parentSandblock isMethod]
]

{ #category : #'as yet unclassified' }
SBBlockBody >> minimumHeight [

	^ self fontToUse height + self layoutInset vertical
]

{ #category : #'as yet unclassified' }
SBBlockBody >> noteNewOwner: aMorph [

	super noteNewOwner: aMorph.
	
	self removeProperty: #sandblockBlockColor
]

{ #category : #converting }
SBBlockBody >> pc [

	^ pc
]

{ #category : #converting }
SBBlockBody >> pc: aNumber [

	pc := aNumber
]

{ #category : #'as yet unclassified' }
SBBlockBody >> prependStatement: aBlock [

	self addMorph: aBlock asElementNumber: 2
]

{ #category : #converting }
SBBlockBody >> printOn: aStream [

	aStream nextPutAll: 'block'
]

{ #category : #converting }
SBBlockBody >> statementCount [

	^ self submorphCount - 1
]

{ #category : #'as yet unclassified' }
SBBlockBody >> statements [

	^ self submorphs allButFirst
]

{ #category : #'as yet unclassified' }
SBBlockBody >> statements: aCollection [

	self submorphs allButFirst do: [:m | self removeMorph: m].
	aCollection do: [:m | self addMorphBack: m]
]

{ #category : #'as yet unclassified' }
SBBlockBody >> symbols [

	^ self isMethodBody ifTrue: [#(nil nil)] ifFalse: [self colorPolicy symbolsForBlock: self]
]

{ #category : #converting }
SBBlockBody >> temporaries [

	^ temporaries submorphs
]

{ #category : #'as yet unclassified' }
SBBlockBody >> temporaries: aCollection [

	temporaries bindings: aCollection
]

{ #category : #converting }
SBBlockBody >> writeSourceOn: aStream [

	self isMethodBody ifFalse: [aStream nextPut: $[].
	
	(bindings hasSubmorphs and: [self isMethodBody not]) ifTrue: [
		bindings submorphsDo: [:m | aStream nextPut: $:. m writeSourceOn: aStream. aStream space].
		aStream nextPut: $|; space].
	
	temporaries writeSourceOn: aStream.
	temporaries hasSubmorphs ifTrue: [aStream cr].
	
	self submorphs allButFirst do: [:m |
		m writeSourceOn: aStream.
		m isExpression ifTrue: [aStream nextPut: $.].
		aStream cr].
	
	self isMethodBody ifFalse: [aStream nextPut: $]]
]
