Class {
	#name : #SBTestCase,
	#superclass : #SBMethodSubstitution,
	#instVars : [
		'selectorInput',
		'errorIndicator'
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
SBTestCase >> childSandblocksDo: aBlock [

	aBlock value: selectorInput.
	aBlock value: self body
]

{ #category : #'as yet unclassified' }
SBTestCase >> clearErrors [

	errorIndicator ifNotNil: [
		errorIndicator detach.
		errorIndicator := nil]
]

{ #category : #'as yet unclassified' }
SBTestCase >> codeActions [

	^ {SBCodeAction labeled: 'Run test' for: self do: [:node | node runTest]}
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
			yourself)
]

{ #category : #'as yet unclassified' }
SBTestCase >> reportError: anError [

	self sandblockEditor reportError: anError process: ((Process
				forContext: anError signalerContext copyStack
				priority: Processor activeProcess priority)
					shouldResumeFromDebugger: false;
					yourself)
	
	"(anError signalerContext findContextSuchThat: [:context | context method selector = self selector and: [context method methodClass = self methodClass]])
		ifNotNil: [:context | (self blockForPC: context previousPc) attachDecorator: (errorIndicator := SBErrorDecorator new message: anError asString)]"
]

{ #category : #'as yet unclassified' }
SBTestCase >> runTest [

	(self saveTryFixing: true quick: false) ifFalse: [^ self].
	self clearErrors.
	[(self methodClass selector: self currentSelector) runCase]
		on: TestResult failure
		do: [:err | 
			self reportError: err.
			err return: false]
		on: TestResult error
		do: [:err | 
			self reportError: err.
			err return: false]
]

{ #category : #'as yet unclassified' }
SBTestCase >> selector [

	^ self currentSelector
]

{ #category : #'as yet unclassified' }
SBTestCase >> writeSignatureSourceOn: aStream [

	aStream nextPutAll: selectorInput contents
]
