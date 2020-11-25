Class {
	#name : #SBBlockBody,
	#superclass : #SBASTNode,
	#instVars : [
		'temporaries',
		'bindings',
		'pc',
		'startPC',
		'endPC'
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

	^ aMorph canAppearInBlockBody
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

{ #category : #'as yet unclassified' }
SBBlockBody >> addElement [
	<action>
	
	self sandblockEditor do: ((SBInsertCommand newFor: self containingArtefact)
		index: self submorphCount + 1;
		container: self;
		morph: SBUnknown new;
		shouldMergeWithNext: true;
		yourself)
]

{ #category : #converting }
SBBlockBody >> addExampleSlider [
	<action>
	
	SBExampleBlockDecoration new wrapAround: self
]

{ #category : #converting }
SBBlockBody >> binding: aString for: block class: aClass ifPresent: aBlock [

	temporaries submorphs detect: [:s | s contents = aString] ifFound: [:s | ^ aBlock value: s] ifNone: [].
	bindings submorphs detect: [:s | s contents = aString] ifFound: [:s | ^ aBlock value: s] ifNone: [].
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBBlockBody >> bindings [

	^ bindings submorphs
]

{ #category : #'as yet unclassified' }
SBBlockBody >> bindings: aCollection [

	aCollection do: [:m | bindings addMorphBack: m]
]

{ #category : #hierarchy }
SBBlockBody >> blockBodyNestingDepth [

	| d node |
	d := 1.
	node := self.
	
	[(node := node containingBlock) notNil] whileTrue: [
		d := d + 1].
	
	^ d
]

{ #category : #'as yet unclassified' }
SBBlockBody >> canDeleteChild: aBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBBlockBody >> cellGap [

	^ self colorPolicy lineGap
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
SBBlockBody >> endPC [

	^ endPC
]

{ #category : #'as yet unclassified' }
SBBlockBody >> endPC: aNumber [

	endPC := aNumber
]

{ #category : #'as yet unclassified' }
SBBlockBody >> evaluateWithArguments: aCollection [

	^ (Compiler evaluate: self sourceString) valueWithEnoughArguments: aCollection
]

{ #category : #converting }
SBBlockBody >> fixedNumberOfChildren [

	^ false
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
		color: Color random;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (SBRow new
			layoutPolicy: SBAlgebraLayout new;
			addMorphBack: bindings;
			addMorphBack: temporaries)
]

{ #category : #'as yet unclassified' }
SBBlockBody >> insertCommandRequest: anAfterBoolean near: aBlock [

	(aBlock notNil and: [
		aBlock isName and: [aBlock isBlockBinding and: [self isMethodBody not]]]) ifTrue: [
		^ (SBInsertCommand newFor: self containingArtefact)
			index: (bindings submorphIndexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
			container: bindings;
			morph: SBName new;
			shouldMergeWithNext: true;
			yourself].
	
	(aBlock notNil and: [aBlock isName and: [aBlock isTemporaryVariable]]) ifTrue: [
		^ (SBInsertCommand newFor: self containingArtefact)
			index: (temporaries submorphIndexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
			container: temporaries;
			morph: SBName new;
			shouldMergeWithNext: true;
			yourself].
	
	^ (SBInsertCommand newFor: self containingArtefact)
		index: (self statements indexOf: aBlock) + (anAfterBoolean ifTrue: [2] ifFalse: [1]);
		container: self;
		morph: SBUnknown new;
		shouldMergeWithNext: true;
		yourself
]

{ #category : #'as yet unclassified' }
SBBlockBody >> isBlockBody [

	^ true
]

{ #category : #converting }
SBBlockBody >> isExpression [

	^ self parentSandblock ifNil: [true] ifNotNil: [:p | p isMethod not]
]

{ #category : #testing }
SBBlockBody >> isMethodBody [

	^ self owner notNil and: [self parentSandblock isMethod]
]

{ #category : #'as yet unclassified' }
SBBlockBody >> layoutCommands [

	| preamble preambleHasContent |
	preamble := self firstSubmorph layoutCommands.
	preambleHasContent := bindings hasSubmorphs or: [temporaries hasSubmorphs].
	
	self statementCount = 0 ifTrue: [^ SBAlgebraCommand container
			morph: self;
			data: {preamble}].
	
	^ (self statementCount > 1 or: [bindings hasSubmorphs and: [temporaries hasSubmorphs]])
		ifTrue: [
			SBAlgebraCommand container
				morph: self;
				data: {
					preamble.
					preambleHasContent ifTrue: [SBAlgebraCommand hardLine] ifFalse: [SBAlgebraCommand noop]},
					(self statements collect: [:stmt | stmt layoutCommands] separatedBy: [SBAlgebraCommand hardLine withGap: true])]
		ifFalse: [
			SBAlgebraCommand container
				morph: self;
				data: ({
					preamble.
					preambleHasContent ifTrue: [SBAlgebraCommand softLine] ifFalse: [SBAlgebraCommand noop].
					self statements first layoutCommands})]
]

{ #category : #hierarchy }
SBBlockBody >> localNestingDepth [

	^ 1
]

{ #category : #'as yet unclassified' }
SBBlockBody >> minHeight [

	^ self fontToUse height + self layoutInset asEdgeInsets y
]

{ #category : #'as yet unclassified' }
SBBlockBody >> minimumHeight [

	^ self fontToUse height + self layoutInset asEdgeInsets vertical
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

{ #category : #'as yet unclassified' }
SBBlockBody >> startPC [

	^ startPC
]

{ #category : #'as yet unclassified' }
SBBlockBody >> startPC: aNumber [

	startPC := aNumber
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
SBBlockBody >> statementsDo: aBlock [

	^ self submorphs allButFirstDo: aBlock
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

{ #category : #'as yet unclassified' }
SBBlockBody >> updatePCFrom: aBlock [

	super updatePCFrom: aBlock.
	self endPC: aBlock endPC.
	self startPC: aBlock startPC
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
		m isPragma ifFalse: [aStream nextPut: $.].
		aStream cr].
	
	self isMethodBody ifFalse: [aStream nextPut: $]]
]
