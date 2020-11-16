Class {
	#name : #SBTestCase,
	#superclass : #SBMethodSubstitution,
	#instVars : [
		'selectorInput',
		'errorIndicator',
		'passIcon',
		'reportedError',
		'autoRun'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBTestCase class >> matches: aMethodBlock [

	^ (super matches: aMethodBlock) and: [aMethodBlock methodClass isTestClass and: [aMethodBlock selector asSymbol isTestSelector and: [aMethodBlock arguments isEmpty]]]
]

{ #category : #'as yet unclassified' }
SBTestCase class >> newFor: anObject [

	| block |
	block := anObject asSandblock.
	^ self new
		selector: block selector arguments: block arguments class: block methodClass;
		body: block body;
		yourself
]

{ #category : #'as yet unclassified' }
SBTestCase class >> newFrom: aMethodBlock [

	^ self new
		selector: aMethodBlock selector arguments: aMethodBlock arguments class: aMethodBlock methodClass;
		body: aMethodBlock body
]

{ #category : #'as yet unclassified' }
SBTestCase >> argumentsDo: aBlock [
]

{ #category : #'as yet unclassified' }
SBTestCase >> artefactSaved: anArtefact [

	super artefactSaved: anArtefact.
	
	self autoRun ifTrue: [self runTest]
]

{ #category : #'as yet unclassified' }
SBTestCase >> autoRun [

	^ autoRun value
]

{ #category : #'as yet unclassified' }
SBTestCase >> autoRun: aBoolean [

	autoRun value: aBoolean
]

{ #category : #'as yet unclassified' }
SBTestCase >> childSandblocksDo: aBlock [

	aBlock value: selectorInput.
	aBlock value: autoRun.
	aBlock value: self body
]

{ #category : #'as yet unclassified' }
SBTestCase >> clearErrors [

	errorIndicator ifNotNil: [
		errorIndicator detach.
		errorIndicator := nil]
]

{ #category : #'as yet unclassified' }
SBTestCase >> currentSelector: aString [

	selectorInput contents: aString.
	super currentSelector: aString
]

{ #category : #'as yet unclassified' }
SBTestCase >> currentTextMorph [

	^ nil
]

{ #category : #'as yet unclassified' }
SBTestCase >> debug [
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
SBTestCase >> drawnColor [

	^ Color veryDarkGray
]

{ #category : #'as yet unclassified' }
SBTestCase >> initialize [

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
			addMorphBack: (passIcon := SBIcon iconCheck
				color: Color lightGreen;
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
SBTestCase >> label [

	^ self selector
]

{ #category : #'as yet unclassified' }
SBTestCase >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			SBAlgebraCommand morph data: self firstSubmorph.
			SBAlgebraCommand hardLine.
			self body layoutCommands
		}
]

{ #category : #'as yet unclassified' }
SBTestCase >> outOfWorld: aWorld [

	super outOfWorld: aWorld.
	
	self sendStopNotification
]

{ #category : #'as yet unclassified' }
SBTestCase >> reportError: anError [

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
SBTestCase >> runTest [
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
SBTestCase >> selector [

	^ self currentSelector
]

{ #category : #'as yet unclassified' }
SBTestCase >> sendFinishNotification [

	self sandblockEditor allMorphsDo: [:morph |
		(morph isSandblock and: [morph listensToExamples]) ifTrue: [morph exampleFinished: self]]
]

{ #category : #'as yet unclassified' }
SBTestCase >> sendStartNotification [

	self sandblockEditor allBlocksDo: [:morph |
		morph listensToExamples ifTrue: [morph exampleStarting: self]]
]

{ #category : #'as yet unclassified' }
SBTestCase >> sendStopNotification [

	self sandblockEditor allMorphsDo: [:morph |
		(morph isSandblock and: [morph listensToExamples]) ifTrue: [morph exampleStopped: self]]
]

{ #category : #'as yet unclassified' }
SBTestCase >> veryDeepCopy [

	| previousError copy |
	previousError := reportedError.
	reportedError := nil.
	
	copy := super veryDeepCopy.
	reportedError := previousError.
	
	^ copy
]

{ #category : #'as yet unclassified' }
SBTestCase >> writeSignatureSourceOn: aStream [

	aStream nextPutAll: selectorInput contents
]
