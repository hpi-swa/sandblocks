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

	^ aMethodBlock methodClass isTestClass and: [aMethodBlock selector asSymbol isTestSelector and: [aMethodBlock arguments isEmpty]]
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
SBTestCase >> drawnColor [

	^ Color veryDarkGray
]

{ #category : #'as yet unclassified' }
SBTestCase >> initialize [

	super initialize.
	self
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 6 withScalingFactor;
		cellGap: 8 withScalingFactor;
		changeTableLayout;
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
			addMorphBack: (autoRun := SBCheckbox new value: true; nonEdit: true);
			addMorphBack: (SBStringMorph new contents: 'Auto-run');
			yourself)
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
		reportedError := nil]
]

{ #category : #'as yet unclassified' }
SBTestCase >> selector [

	^ self currentSelector
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
