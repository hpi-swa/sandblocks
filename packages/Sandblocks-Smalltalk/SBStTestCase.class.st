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
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStTestCase class >> matches: aMethodBlock [

	^ (super matches: aMethodBlock) and: [aMethodBlock methodClass isTestClass and: [aMethodBlock selector asSymbol isTestSelector and: [aMethodBlock numArgs = 0]]]
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

{ #category : #'as yet unclassified' }
SBStTestCase >> argumentsDo: aBlock [
]

{ #category : #'as yet unclassified' }
SBStTestCase >> artefactSaved: anArtefact [

	super artefactSaved: anArtefact.
	
	self autoRun ifTrue: [self runTest]
]

{ #category : #'as yet unclassified' }
SBStTestCase >> autoRun [

	^ autoRun value
]

{ #category : #'as yet unclassified' }
SBStTestCase >> autoRun: aBoolean [

	autoRun value: aBoolean
]

{ #category : #'as yet unclassified' }
SBStTestCase >> childSandblocksDo: aBlock [

	aBlock value: selectorInput.
	aBlock value: autoRun.
	aBlock value: self body
]

{ #category : #'as yet unclassified' }
SBStTestCase >> clearErrors [

	errorIndicator ifNotNil: [
		errorIndicator detach.
		errorIndicator := nil]
]

{ #category : #'as yet unclassified' }
SBStTestCase >> currentSelector: aString [

	selectorInput contents: aString.
	super currentSelector: aString
]

{ #category : #'as yet unclassified' }
SBStTestCase >> currentTextMorph [

	^ nil
]

{ #category : #'as yet unclassified' }
SBStTestCase >> debug [
	<action>

	| testCase |
	testCase := self methodClass selector: self currentSelector.
	
	SBToggledCode comment: 'doesn''t work yet :(' active: 1 do: {[self flag: #fixme]}.
	
	[testCase debugAsFailure]
		on: Halt
		do: [:halt |
			self sandblockEditor
				reportError: halt
				process: ((Process forContext: halt signalerContext copyStack priority: Processor activeProcess priority)
					shouldResumeFromDebugger: false;
					yourself).
			self sandblockEditor errors focusErrors]
]

{ #category : #'as yet unclassified' }
SBStTestCase >> drawnColor [

	^ Color veryDarkGray
]

{ #category : #'as yet unclassified' }
SBStTestCase >> initialize [

	super initialize.
	self
		useAlgebraLayout;
		layoutInset: 6 withScalingFactor;
		cellGap: 8 withScalingFactor;
		addMorphBack: (SBRow new
			cellGap: 8 withScalingFactor;
			addMorphBack: (selectorInput := SBTextBubble new
				colored: false;
				layoutInset: 5 withScalingFactor;
				yourself);
			addMorphBack: (SBIcon iconPlay on: #click send: #runTest to: self);
			addMorphBack: (Morph new
				width: 6;
				height: 0;
				color: Color transparent;
				yourself);
			addMorphBack: (passIcon := SBIcon iconQuestion
				color: Color white;
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
			yourself);
		attachDecorator: SBResizableDecorator new
]

{ #category : #'as yet unclassified' }
SBStTestCase >> label [

	^ self selector
]

{ #category : #'as yet unclassified' }
SBStTestCase >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {SBAlgebraCommand morph data: self firstSubmorph}, (self body visible
			ifTrue: [{SBAlgebraCommand hardLine. self body layoutCommands}]
			ifFalse: [{}])
]

{ #category : #'as yet unclassified' }
SBStTestCase >> objectInterfaceAt: aNumber adding: aBoolean [

	aBoolean ifTrue: [^ SBInterfaces never].
	
	^ aNumber = self childSandblocks size
		ifTrue: [SBInterfaces stBlock]
		ifFalse: [SBInterfaces stName]
]

{ #category : #'as yet unclassified' }
SBStTestCase >> outOfWorld: aWorld [

	super outOfWorld: aWorld.
	
	self sendStopNotification
]

{ #category : #'as yet unclassified' }
SBStTestCase >> reportError: anError [

	passIcon changeIconName: #iconRemove; color: Color red.
	
	reportedError ifNotNil: #delete.
	reportedError := self sandblockEditor reportError: anError process: ((Process
				forContext: anError signalerContext copyStack
				priority: Processor activeProcess priority)
					shouldResumeFromDebugger: false;
					yourself)
	
	"(anError signalerContext findContextSuchThat: [:context | context method selector = self selector and: [context method methodClass = self methodClass]])
		ifNotNil: [:context | (self blockForPC: context previousPc) attachDecorator: (errorIndicator := SBErrorDecorator new message: anError asString)]"
]

{ #category : #'as yet unclassified' }
SBStTestCase >> runTest [
	<action>

	SBExecutionEnvironment value: self.
	
	self sendStartNotification.
	
	self clearErrors.
	passIcon
		changeIconName: #'iconClock_o';
		color: Color yellow.
	([(self methodClass selector: self currentSelector) runCase. true]
		on: TestResult failure
		do: [:err |
			self reportError: err.
			err return: false]
		on: TestResult error
		do: [:err |
			self reportError: err.
			err return: false]) ifTrue: [
		passIcon
			changeIconName: #iconCheck;
			color: Color lightGreen.
		reportedError ifNotNil: #delete.
		reportedError := nil].
	
	self sendFinishNotification.
	SBExecutionEnvironment value: nil
]

{ #category : #'as yet unclassified' }
SBStTestCase >> selector [

	^ self currentSelector
]

{ #category : #'as yet unclassified' }
SBStTestCase >> sendFinishNotification [

	self sandblockEditor allMorphsDo: [:morph |
		(morph isSandblock and: [morph listensToExamples]) ifTrue: [morph exampleFinished: self]]
]

{ #category : #'as yet unclassified' }
SBStTestCase >> sendStartNotification [

	self sandblockEditor allBlocksDo: [:morph |
		morph listensToExamples ifTrue: [morph exampleStarting: self]]
]

{ #category : #'as yet unclassified' }
SBStTestCase >> sendStopNotification [

	self sandblockEditor allMorphsDo: [:morph |
		(morph isSandblock and: [morph listensToExamples]) ifTrue: [morph exampleStopped: self]]
]

{ #category : #'as yet unclassified' }
SBStTestCase >> veryDeepCopy [

	| previousError copy |
	previousError := reportedError.
	reportedError := nil.
	
	copy := super veryDeepCopy.
	reportedError := previousError.
	
	^ copy
]

{ #category : #'as yet unclassified' }
SBStTestCase >> writeSignatureSourceOn: aStream [

	aStream nextPutAll: selectorInput contents
]
