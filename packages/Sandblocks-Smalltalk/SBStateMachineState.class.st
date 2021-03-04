Class {
	#name : #SBStateMachineState,
	#superclass : #SBBlock,
	#instVars : [
		'label'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStateMachineState >> addEnterAction [
	<action>

	self addUponEnter: SBStBlockBody empty
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> addLeaveAction [
	<action>

	self addUponLeave: SBStBlockBody empty
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> addUponEnter: aBlock [

	self addMorphBack: (SBRow new
		softWrap: false;
		useAlgebraLayout;
		cellGap: 4 withScalingFactor;
		addMorphBack: (SBStringMorph new contents: 'Enter:');
		addMorphBack: aBlock)
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> addUponLeave: aBlock [

	self addMorphBack: (SBRow new
		softWrap: false;
		useAlgebraLayout;
		cellGap: 4 withScalingFactor;
		addMorphBack: (SBStringMorph new contents: 'Leave:');
		addMorphBack: aBlock)
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> childSandblocksDo: aBlock [

	aBlock value: label.
	self submorphs from: 2 to: self submorphCount do: [:m |
		aBlock value: m submorphs second]
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> connectTo [
	<action>

	| states index |
	states := self owner states collect: #name.
	index := UIManager default chooseFrom: states.
	index > 0 ifTrue: [
		self owner connect: self name to: (states at: index) type: #condition data: SBStBlockBody empty]
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> deleteCommandFor: aBlock [

	^ (SBDeleteCommand newFor: aBlock containingArtefact) target: aBlock owner
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> drawBackgroundOn: aCanvas [

	aCanvas
		frameAndFillRoundRect: self bounds
		radius: 15
		fillStyle: self drawnColor
		borderWidth: (self colorPolicy borderWidthForBlock: self)
		borderColor: (self colorPolicy borderColorForBlock: self)
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> initialize [

	super initialize.
	self addMorphBack: (label := SBTextBubble new placeholderText: 'unnamed state').
	self
		useAlgebraLayout;
		extent: 280 @ 10;
		vResizing: #shrinkWrap;
		hResizing: #rigid;
		layoutInset: 6 withScalingFactor;
		attachDecorator: SBMoveDecorator new;
		attachDecorator: SBResizableDecorator new
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> insertCommandRequest: anAfterBoolean near: aBlock [

	| body |
	body := SBStBlockBody empty.
	^ (SBInsertCommand newFor: self containingArtefact)
		index: ((self childSandblocks indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]) max: 2);
		container: self;
		morph: (SBRow new
			cellGap: 4 withScalingFactor;
			addMorphBack: (SBStringMorph new contents: 'Enter:');
			addMorphBack: body);
		select: body childSandblocks first;
		shouldMergeWithNext: true;
		yourself
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> isSmalltalk [

	^ true
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand hardLine withGap: true])
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> name [

	^ label contents
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> name: aString [

	label contents: aString
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> object [

	^ self
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> preferredColor [

	^ SBStASTNode preferredColor
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> printOn: aStream [

	aStream nextPutAll: self className; nextPut: $(; nextPutAll: self name; nextPut: $)
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> setAsInitialState [
	<action>

	self parentSandblock initialState: self
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> startInputAt: aNumber replacingContents: aBoolean [

	self sandblockEditor replaceInput: self firstSubmorph.
	^ self firstSubmorph startInputAt: aNumber replacingContents: aBoolean
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> symbols [

	^ {((self owner isKindOf: SBStateMachineEditor) and: [self owner initialState = self]) ifTrue: ['* '] ifFalse: [nil]. nil}
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> updatePCFrom: anObject [
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> uponEnterBlocks [

	^ ((self submorphs copyFrom: 2) select: [:row | row submorphs first contents = 'Enter:']) collect: [:row | row submorphs second]
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> uponLeaveBlocks [

	^ ((self submorphs copyFrom: 2) select: [:row | row submorphs first contents = 'Leave:']) collect: [:row | row submorphs second]
]
