Class {
	#name : #SBStBlockBody,
	#superclass : #SBStASTNode,
	#instVars : [
		'temporaries',
		'bindings',
		'pc',
		'startPC',
		'endPC'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStBlockBody class >> empty [

	^ SBStBlockBody new in: [:body |
		body
			statements: {body newNullBlock};
			temporaries: {};
			bindings: {}]
]

{ #category : #'as yet unclassified' }
SBStBlockBody class >> emptyWithDeclarations: aCollectionOfStrings [

	^ SBStBlockBody new in: [:body |
		body
			statements: {body newNullBlock};
			temporaries: {};
			bindings: (aCollectionOfStrings collect: [:s | SBStName contents: s]);
			yourself]
]

{ #category : #converting }
SBStBlockBody >> addBlockArgument [

	self sandblockEditor
		endInput;
		do: (SBInsertCommand new
			index: bindings submorphCount + 1;
			container: bindings;
			morph: SBStName new;
			shouldMergeWithNext: true;
			yourself);
		startInput: self sandblockEditor selection at: 0 replacingContents: false
]

{ #category : #converting }
SBStBlockBody >> addExampleSlider [
	<action>
	
	SBExampleBlockDecoration new wrapAround: self
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> appendElement [
	<action>

	self sandblockEditor do: (SBInsertCommand new
		index: self submorphCount + 1;
		container: self;
		morph: self newNullBlock;
		shouldMergeWithNext: true;
		yourself).
	
	self sandblockEditor
		startInput: self sandblockEditor selection
		at: 0
		replacingContents: false
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> appendStatements: aCollection [

	self addAllMorphs: aCollection
]

{ #category : #converting }
SBStBlockBody >> binding: aString for: block class: aClass ifPresent: aBlock [

	temporaries submorphs detect: [:s | s contents = aString] ifFound: [:s | ^ aBlock value: s] ifNone: [].
	bindings submorphs detect: [:s | s contents = aString] ifFound: [:s | ^ aBlock value: s] ifNone: [].
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> bindings [

	^ bindings submorphs
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> bindings: aCollection [

	aCollection do: [:m | bindings addMorphBack: m]
]

{ #category : #hierarchy }
SBStBlockBody >> blockBodyNestingDepth [

	| d node |
	d := 1.
	node := self.
	
	[(node := node containingBlock) notNil] whileTrue: [
		d := d + 1].
	
	^ d
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> canDeleteChild: aBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> cellGap [

	^ self colorPolicy lineGap
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> declareTemporaryVariable: aString [

	self sandblockEditor do: (self declareTemporaryVariableCommand: aString)
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> declareTemporaryVariableCommand: aString [

	^ temporaries submorphs
		detect: [:t | t contents = aString]
		ifFound: [:temp | SBDoItCommand new do: []]
		ifNone: [
			SBInsertCommand new
				container: temporaries;
				index: temporaries submorphCount + 1;
				morph: (SBStName contents: aString);
				yourself]
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> endPC [

	^ endPC
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> endPC: aNumber [

	endPC := aNumber
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> evaluateWithArguments: aCollection [

	^ (Compiler evaluate: self sourceString) valueWithEnoughArguments: aCollection
]

{ #category : #converting }
SBStBlockBody >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> guessedClass [

	^ BlockClosure
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> initialize [

	super initialize.
	
	bindings := SBStBlockBindings new.
	temporaries := SBStTemporaries new.
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
SBStBlockBody >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	(aBlock notNil and: [aBlock owner = bindings]) ifTrue: [
		^ SBRelInsertCommand new
			near: aBlock before: aBoolean in: bindings morph: aMorph;
			shouldMergeWithNext: true;
			yourself].
	
	(aBlock notNil and: [aBlock owner = temporaries]) ifTrue: [
		^ SBRelInsertCommand new
			near: aBlock before: aBoolean in: temporaries morph: aMorph;
			shouldMergeWithNext: true;
			yourself].
	
	(aBlock isNil and: [aBoolean]) ifTrue: [
		" make sure we don't insert before our bindings/temps "
		^ SBInsertCommand new
			container: self;
			index: 2;
			morph: aMorph;
			shouldMergeWithNext: true].
	
	^ (super insertCommandRequest: aMorph near: aBlock before: aBoolean) shouldMergeWithNext: true
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> isBlockBody [

	^ true
]

{ #category : #converting }
SBStBlockBody >> isExpression [

	^ self parentSandblock ifNil: [true] ifNotNil: [:p | p isMethod not]
]

{ #category : #testing }
SBStBlockBody >> isMethodBody [

	^ self owner notNil and: [self parentSandblock wantsMethodBody]
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> layoutCommands [

	| preamble preambleHasContent multiLine |
	multiLine := self statementCount > 1 or: [temporaries hasSubmorphs].
	preambleHasContent := bindings hasSubmorphs or: [temporaries hasSubmorphs].
	preamble := SBAlgebraCommand container
		morph: self firstSubmorph;
		data: ((self firstSubmorph submorphs select: #visible) collect: #layoutCommands separatedBy: [bindings hasSubmorphs ifTrue: [SBAlgebraCommand softLineOrGap] ifFalse: [SBAlgebraCommand noop]]).
	
	self statementCount = 0 ifTrue: [
		^ SBAlgebraCommand container
			morph: self;
			data: {preamble}].
	
	^ multiLine
		ifTrue: [
			SBAlgebraCommand container
				morph: self;
				data: {
					preamble.
					preambleHasContent
						ifTrue: [SBAlgebraCommand hardLine]
						ifFalse: [SBAlgebraCommand noop]}, (self statements
					collect: [:stmt | stmt layoutCommands]
					separatedBy: [SBAlgebraCommand hardLine withGap: true])]
		ifFalse: [
			SBAlgebraCommand container
				morph: self;
				data: {
					preamble.
					preambleHasContent
						ifTrue: [SBAlgebraCommand softLine]
						ifFalse: [SBAlgebraCommand noop].
					self statements first layoutCommands}]
]

{ #category : #hierarchy }
SBStBlockBody >> localNestingDepth [

	^ 1
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> minHeight [

	^ self fontToUse height + self layoutInset asEdgeInsets y
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> minimumHeight [

	^ self fontToUse height + self layoutInset asEdgeInsets vertical
]

{ #category : #converting }
SBStBlockBody >> multiSelectChildren [
	<multiSelectAction>

	self statements do: [:c | c isMultiSelected ifFalse: [c startOrAddToMultiSelection]]
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> newEmptyChildNear: aBlock before: aBoolean [

	(aBlock isSandblock and: [aBlock isName and: [aBlock isBlockBinding]]) ifTrue: [^ SBStName new].
	^ super newEmptyChildNear: aBlock before: aBoolean
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> objectInterfaceNear: aBlock at: aSymbol [

	({bindings. temporaries} includes: (aBlock ifNotNil: #owner)) ifTrue: [^ SBInterfaces stName].
	
	^ SBInterfaces stCanAppearInBlock
]

{ #category : #converting }
SBStBlockBody >> pc [

	^ pc
]

{ #category : #converting }
SBStBlockBody >> pc: aNumber [

	pc := aNumber
]

{ #category : #'colors and color policies' }
SBStBlockBody >> preferredColorIn: aColorPolicy [

	^ aColorPolicy important
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> prependStatement: aBlock [

	self addMorph: aBlock asElementNumber: 2
]

{ #category : #converting }
SBStBlockBody >> printOn: aStream [

	aStream nextPutAll: 'block'
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> startPC [

	^ startPC
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> startPC: aNumber [

	startPC := aNumber
]

{ #category : #converting }
SBStBlockBody >> statementCount [

	^ self submorphCount - 1
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> statements [

	^ self submorphs allButFirst
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> statements: aCollection [

	self submorphs allButFirst do: [:m | self removeMorph: m].
	aCollection do: [:m | self addMorphBack: m]
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> statementsDo: aBlock [

	^ self submorphs allButFirstDo: aBlock
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> symbols [

	^ self isMethodBody ifTrue: [#(nil nil)] ifFalse: [self colorPolicy symbolsForBlock: self]
]

{ #category : #converting }
SBStBlockBody >> temporaries [

	^ temporaries submorphs
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> temporaries: aCollection [

	temporaries bindings: aCollection
]

{ #category : #'as yet unclassified' }
SBStBlockBody >> updatePCFrom: aBlock [

	super updatePCFrom: aBlock.
	self endPC: aBlock endPC.
	self startPC: aBlock startPC
]

{ #category : #converting }
SBStBlockBody >> writeSourceOn: aStream [

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
