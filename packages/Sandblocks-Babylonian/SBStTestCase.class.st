Class {
	#name : #SBStTestCase,
	#superclass : #SBStMethodSubstitution,
	#instVars : [
		'selectorInput',
		'errorIndicator',
		'passIcon',
		'reportedError',
		'autoRun'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'as yet unclassified' }
SBStTestCase class >> matchSpecific: aMethodBlock [

	^ aMethodBlock methodClass isTestClass and: [aMethodBlock selector asSymbol isTestSelector and: [aMethodBlock numArgs = 0]]
]

{ #category : #'as yet unclassified' }
SBStTestCase class >> newFor: anObject [

	| block |
	block := anObject asSandblock.
	^ self new
		selector: block selector arguments: block arguments class: block methodClass;
		body: block body;
		yourself
]

{ #category : #'as yet unclassified' }
SBStTestCase class >> newFrom: aMethodBlock [

	^ self new
		selector: aMethodBlock selector arguments: aMethodBlock arguments class: aMethodBlock methodClass;
		body: aMethodBlock body
]

{ #category : #'method protocol' }
SBStTestCase >> argumentsDo: aBlock [
]

{ #category : #callbacks }
SBStTestCase >> artefactSaved: anArtefact [

	super artefactSaved: anArtefact.
	
	self autoRun ifTrue: [self runTest]
]

{ #category : #accessing }
SBStTestCase >> autoRun [

	^ autoRun value
]

{ #category : #accessing }
SBStTestCase >> autoRun: aBoolean [

	autoRun value: aBoolean
]

{ #category : #errors }
SBStTestCase >> clearErrors [

	errorIndicator ifNotNil: [
		errorIndicator detach.
		errorIndicator := nil]
]

{ #category : #accessing }
SBStTestCase >> currentSelector: aString [

	selectorInput contents: aString.
	super currentSelector: aString
]

{ #category : #accessing }
SBStTestCase >> currentTextMorph [

	^ nil
]

{ #category : #actions }
SBStTestCase >> debug [
	<action>

	| testCase |
	testCase := self methodClass selector: self currentSelector.
	
	SBToggledCode comment: 'doesn''t work yet :(' active: 1 do: {[self flag: #fixme]}.
	
	[testCase debugAsFailure] on: Halt do: [:halt |
		self sandblockEditor
			reportError: halt
			process: ((Process forContext: halt signalerContext copyStack priority: Processor activeProcess priority)
				shouldResumeFromDebugger: false;
				yourself)
			source: self.
		self sandblockEditor errors focusErrors]
]

{ #category : #'colors and color policies' }
SBStTestCase >> drawnColor [

	^ self colorPolicy toolColorFor: self
]

{ #category : #actions }
SBStTestCase >> execute [

	^ self methodClass new perform: self currentSelector
]

{ #category : #'examples protocol' }
SBStTestCase >> executeForBlock: aBlock ifFound: aClosure [

	^ [
		(Smalltalk at: #SBStRunUntilSandbox) new
			selector: aBlock containingArtefact selector;
			receiverClass: aBlock containingArtefact methodClass;
			pc: aBlock pc;
			evaluate: [self methodClass new perform: self currentSelector]]
		on: SBStRunUntilValue
		do: [:val | aClosure value: val value]
]

{ #category : #'initialize-release' }
SBStTestCase >> initialize [

	super initialize.
	self
		useAlgebraLayout;
		layoutInset: 6;
		cellGap: 8;
		addMorphBack: (SBRow new
			hResizing: #spaceFill;
			cellGap: 8;
			changeTableLayout;
			addMorphBack: (selectorInput := SBTextBubble new
				colored: false;
				layoutInset: 5;
				yourself);
			addMorphBack: (SBIcon iconPlay on: #click send: #runTest to: self);
			addMorphBack: (Morph new
				width: 6;
				height: 0;
				color: Color transparent;
				yourself);
			addMorphBack: (passIcon := SBIcon iconQuestion
				color: (Color r: 1 g: 1 b: 1);
				on: #click send: #openError to: self;
				yourself);
			addMorphBack: (Morph new
				width: 6;
				height: 0;
				color: Color transparent;
				yourself);
			addMorphBack: (autoRun := SBCheckbox new
				value: true;
				nonEdit: true;
				when: #toggled send: #sendStopNotification to: self);
			addMorphBack: (SBStringMorph new contents: 'Auto-run');
			addMorphBack: (Morph new
				hResizing: #spaceFill;
				height: 0;
				color: Color transparent;
				yourself);
			yourself);
		attachDecorator: SBResizableDecorator new
]

{ #category : #accessing }
SBStTestCase >> label [

	^ self selector
]

{ #category : #layout }
SBStTestCase >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {SBAlgebraCommand morph data: self firstSubmorph}, (self body visible
			ifTrue: [{SBAlgebraCommand hardLine. self body layoutCommands}]
			ifFalse: [{}])
]

{ #category : #'object interface' }
SBStTestCase >> objectInterfaceNear: aBlock at: aSymbol [

	aSymbol ~= #replace ifTrue: [^ SBInterfaces never].
	
	^ aBlock isLastChild ifTrue: [SBInterfaces stBlock] ifFalse: [SBInterfaces stName]
]

{ #category : #errors }
SBStTestCase >> openError [

	(self methodClass selector: self currentSelector) runCase
]

{ #category : #'initialize-release' }
SBStTestCase >> outOfWorld: aWorld [

	super outOfWorld: aWorld.
	
	self sendStopNotification
]

{ #category : #testing }
SBStTestCase >> providesExecutionEnvironment [

	^ true
]

{ #category : #errors }
SBStTestCase >> reportError: anError [

	passIcon
		changeIconName: #iconRemove;
		color: (Color r: 1 g: 0.0 b: 0.0).
	
	reportedError ifNotNil: #delete.
	reportedError := self sandblockEditor
		reportError: anError
		process: ((Process forContext: anError signalerContext copyStack priority: Processor activeProcess priority)
			shouldResumeFromDebugger: false;
			yourself)
		source: self
	"(anError signalerContext findContextSuchThat: [:context | context method selector = self selector and: [context method methodClass = self methodClass]])
		ifNotNil: [:context | (self blockForPC: context previousPc) attachDecorator: (errorIndicator := SBErrorDecorator new message: anError asString)]"
]

{ #category : #actions }
SBStTestCase >> runTest [
	<action>

	SBExecutionEnvironment value: self during: [
		self sendStartNotification.
	
		self clearErrors.
		passIcon
			changeIconName: #'iconClockO';
			color: Color yellow.
		([(self methodClass selector: self currentSelector) runCase. true]
			on: TestResult failure
			do: [:err |
				self reportError: err.
				err return: false]
			on: TestResult exError
			do: [:err |
				self reportError: err.
				err return: false]) ifTrue: [
			passIcon
				changeIconName: #iconCheck;
				color: Color lightGreen.
			reportedError ifNotNil: #delete.
			reportedError := nil].
	
		self sendFinishNotification.
		SBExecutionEnvironment value: nil]
]

{ #category : #'method protocol' }
SBStTestCase >> selector [

	^ selectorInput contents
]

{ #category : #'examples protocol' }
SBStTestCase >> sendFinishNotification [

	self sandblockEditor allMorphsDo: [:morph |
		(morph isSandblock and: [morph listensToExamples]) ifTrue: [morph exampleFinished: self]]
]

{ #category : #'examples protocol' }
SBStTestCase >> sendStartNotification [

	self sandblockEditor allBlocksDo: [:morph |
		morph listensToExamples ifTrue: [morph exampleStarting: self]]
]

{ #category : #'examples protocol' }
SBStTestCase >> sendStopNotification [

	self sandblockEditor allMorphsDo: [:morph |
		(morph isSandblock and: [morph listensToExamples]) ifTrue: [morph exampleStopped: self]]
]

{ #category : #'method protocol' }
SBStTestCase >> showRenameHint: aMorph [

	self firstSubmorph addMorphBack: aMorph
]

{ #category : #copying }
SBStTestCase >> veryDeepCopy [

	| previousError copy |
	previousError := reportedError.
	reportedError := nil.
	
	copy := super veryDeepCopy.
	reportedError := previousError.
	
	^ copy
]

{ #category : #'method protocol' }
SBStTestCase >> writeSignatureSourceOn: aStream [

	aStream nextPutAll: selectorInput contents
]
