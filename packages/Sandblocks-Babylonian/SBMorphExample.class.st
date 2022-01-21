"
A SBMorphExample partially sandboxes a morph in its own pasteupmorph. Together with the SBMorphExampleCase it will reopen the morph when requested.
"
Class {
	#name : #SBMorphExample,
	#superclass : #SBStSubstitution,
	#instVars : [
		'view',
		'cases',
		'errorDecorator',
		'header',
		'errorIcon',
		'reportedError',
		'recordedEvents'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'as yet unclassified' }
SBMorphExample class >> buildTemplateFor: aBlock extent: aPoint [

	"| setUp |
	setUp := SBStBlockBody empty.
	aBlock sandblockEditor selectedArtefact relatedClass ifNotNil: [:class | setUp statements: {SBStMessageSend new receiver: (SBStName contents: class name) selector: #new}]."
	
	^ (SBMorphExample new setUp: '[self class new]' parseAsSandblock cases: {} extent: aPoint)
		addCase: ((SBStBlockBody emptyWithDeclarations: {'m'}) statements: {SBStName contents: 'm'})
		name: 'example 1'
]

{ #category : #'as yet unclassified' }
SBMorphExample class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].

	^ (aBlock receiver satisfies: #(notNil isBinding)) and: [aBlock receiver contents = self name] and: [aBlock selector = 'setUp:cases:extent:']
]

{ #category : #'as yet unclassified' }
SBMorphExample class >> newFor: aBlock [

	^ self new
		setUp: aBlock arguments first
		cases: aBlock arguments second submorphs
		extent: aBlock arguments third contents
]

{ #category : #'as yet unclassified' }
SBMorphExample class >> setUp: aBlock cases: aCollectionOfBlocks extent: aPoint [

	" marker "
]

{ #category : #'as yet unclassified' }
SBMorphExample class >> suggestion [

	^ [:block |
		block sandblockEditor do: (SBReplaceCommand new
			target: block;
			replacer: (self buildTemplateFor: block extent: 300 asPoint);
			yourself)]
]

{ #category : #callbacks }
SBMorphExample >> addCase: aBlock name: aString [

	cases addMorphBack: (SBMorphExampleCase new
		name: aString caseBlock: aBlock;
		when: #run send: #runCase: to: self;
		when: #startRecord evaluate: [:list | recordedEvents := list];
		when: #stopRecord evaluate: [recordedEvents := nil])
]

{ #category : #callbacks }
SBMorphExample >> artefactChanged: anArtefact [

	" re-trigger e.g. a changed drawOn: "
	view changed
]

{ #category : #testing }
SBMorphExample >> canDeleteChild: aBlock [

	^ aBlock owner = cases
]

{ #category : #accessing }
SBMorphExample >> cases [

	^ cases submorphs
]

{ #category : #errors }
SBMorphExample >> clearErrors [

	errorDecorator ifNotNil: [
		errorDecorator detach.
		errorDecorator := nil].
	
	errorIcon ifNotNil: [
		errorIcon delete.
		errorIcon := nil]
]

{ #category : #errors }
SBMorphExample >> displayError: anError [

	header addMorphBack: (errorIcon := SBIcon iconFlash balloonText: anError asString)
]

{ #category : #colors }
SBMorphExample >> drawnColor [

	^ self colorPolicy toolColorFor: self
]

{ #category : #testing }
SBMorphExample >> execute [

	| morph |
	morph := self setUpMorph evaluate.
	morph ifNotNil: [ | tempView |
		tempView := SBSandboxPasteUpMorph new.
		tempView addMorphBack: (morph
			fullBounds;
			center: tempView center).
		self cases first evaluateFor: morph in: tempView]
]

{ #category : #events }
SBMorphExample >> filterEvent: anEvent for: anObject [

	recordedEvents ifNotNil: [(anEvent isMouseUp or: [anEvent isMouseDown or: [anEvent isKeyboard]]) ifTrue: [recordedEvents add: anEvent]].
	^ anEvent
]

{ #category : #initialization }
SBMorphExample >> initialize [

	super initialize.
	
	self
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutPolicy: SBAlgebraLayout new;
		layoutInset: 6;
		addMorphBack: (TransformMorph new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			changeTableLayout;
			addMorph: (view := SBSandboxPasteUpMorph new when: #reportError send: #reportError: to: self));
		addMorphBack: (cases := SBColumn new layoutInset: 0)
]

{ #category : #testing }
SBMorphExample >> isExpression [

	^ false
]

{ #category : #testing }
SBMorphExample >> isMorphExample [

	^ true
]

{ #category : #'as yet unclassified' }
SBMorphExample >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (Array streamContents: [:stream |
			self submorphs
				do: [:m | stream nextPut: m layoutCommands]
				separatedBy: [stream nextPut: (SBAlgebraCommand hardLine withGap: true)]])
]

{ #category : #helper }
SBMorphExample >> methodForContext: aContext ifOpen: aBlock ifClosed: anotherBlock [

	^ self sandblockEditor methods
		detect: [:m | m methodClass = aContext methodClass and: [m selector = aContext selector]]
		ifFound: aBlock
		ifNone: anotherBlock
]

{ #category : #callbacks }
SBMorphExample >> newEmptyChildNear: aBlock before: aBoolean [

	^ (SBMorphExampleCase new
		name: ''
		caseBlock: (SBStBlockBody emptyWithDeclarations: {'m'}))
		when: #run
		send: #runCase:
		to: self
]

{ #category : #initialization }
SBMorphExample >> pickAndExplore [
	<action>

	self sandblockEditor openMorphInView: (SBExplorer on: (self outermostWorldMorph morphsAt: (Cursor crossHair showWhile: [Sensor waitButton])) first)
]

{ #category : #testing }
SBMorphExample >> providesExecutionEnvironment [

	^ true
]

{ #category : #errors }
SBMorphExample >> reportError: anError [

	| editor ctx i |
	self
		clearErrors;
		displayError: anError.
	
	true ifTrue: [ | priority stack |
		(reportedError notNil and: [reportedError expanded not]) ifTrue: [reportedError delete].
		
		stack := anError signalerContext copyStack.
		priority := Processor activeProcess priority.
		^ Project current addDeferredUIMessage: [
			reportedError := self sandblockEditor
				reportError: anError
				process: ((Process forContext: stack priority: priority)
					shouldResumeFromDebugger: false;
					yourself)
				source: self
			"ToolSet debugException: anError"]].
	
	editor := self sandblockEditor.
	i := 1.
	ctx := anError signalerContext.
	[ctx] whileNotNil: [
		" error was during our example case setup, locate the correct expression from the DoIt "
		ctx method = (SBMorphExampleCase >> #evaluateFor:in:) ifTrue: [ | caseBlock doItCtx |
			caseBlock := self cases first caseBlock.
			doItCtx := anError signalerContext stack at: i - 3.
			" this 73 currently is a mystery, but maybe it's caseBlock pc - doItCtx method initialPC ? further investigation needed "
			(caseBlock containingArtefact blockForPC: doItCtx pc + 73) ifNotNil: [:b | b attachDecorator: (errorDecorator := SBErrorDecorator new message: anError asString)].
			^ self].
		
		" error was elsewhere, see if we have an open artefact with this context "
		self
			methodForContext: ctx
			ifOpen: [:method |
				(method blockForPC: ctx previousPc) ifNotNil: [:b | b attachDecorator: (errorDecorator := SBErrorDecorator new message: anError asString)].
				^ self]
			ifClosed: [false].
		ctx := ctx sender.
		i := i + 1]
]

{ #category : #callbacks }
SBMorphExample >> runCase: aCase [

	| morph |
	"self sendStartNotification."
	
	self clearErrors.
	view removeAllMorphs.
	
	[
		morph := self setUpMorph evaluate.
		morph ifNotNil: [
			view addMorphBack: (morph fullBounds; center: view center).
			aCase evaluateFor: morph in: view]
	] on: Error do: [:error | ^ self reportError: error]
]

{ #category : #helper }
SBMorphExample >> sendStartNotification [

	self sandblockEditor allBlocksDo: [:morph |
		morph isGlobalWatch ifTrue: [morph exampleStarting: self]]
]

{ #category : #initialization }
SBMorphExample >> setUp: aBlock cases: aCollectionOfBlocks extent: aPoint [

	self addMorph: (header := SBRow new
		layoutPolicy: SBAlgebraLayout new;
		cellGap: 8 * self scalingFactor;
		addMorphBack: (SBStringMorph new contents: 'Setup:');
		addMorphBack: aBlock statements first veryDeepCopy;
		addMorphBack: (SBIcon iconSpinner
			balloonText: 'Toggle stepping';
			on: #click send: #toggleStepping to: self);
		addMorphBack: (SBIcon iconCrosshairs
			balloonText: 'Pick & Explore';
			on: #click send: #pickAndExplore to: self)).
	
	aCollectionOfBlocks do: [:m | self addCase: m arguments second veryDeepCopy name: m arguments first contents].
	
	view extent: aPoint
]

{ #category : #accessing }
SBMorphExample >> setUpMorph [

	" we can't just save a reference to it because editing ops may change the morph, but it's position will say the same "
	^ self firstSubmorph submorphs second
]

{ #category : #callbacks }
SBMorphExample >> toggleStepping [
	<action>

	view submorphsDo: [:morph |
		morph isStepping ifFalse: [morph startStepping] ifTrue: [morph stopStepping]]
]

{ #category : #errors }
SBMorphExample >> veryDeepCopyWith: aCopier [

	| copy oldError |
	oldError := reportedError.
	reportedError := nil.
	
	copy := super veryDeepCopyWith: aCopier.
	reportedError := oldError.
	
	^ copy
]

{ #category : #accessing }
SBMorphExample >> view [

	^ view
]

{ #category : #printing }
SBMorphExample >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBMorphExample setUp: ['.
	self setUpMorph writeSourceOn: aStream.
	aStream nextPutAll: '] cases: '.
	(SBStArray withContents: self cases veryDeepCopy) writeSourceOn: aStream.
	aStream nextPutAll: ' extent: '.
	view extent storeOn: aStream.
	aStream nextPut: $)
]
