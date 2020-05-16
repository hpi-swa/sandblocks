Class {
	#name : #SBExample,
	#superclass : #SBSubstitution,
	#instVars : [
		'icon',
		'lastError',
		'errorIndicator',
		'currentProcess',
		'processRunning',
		'currentSelf',
		'nameInput',
		'active',
		'errorDecorator',
		'returnValue',
		'reportedError'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBExample class >> getAllInMethod: aBlock [

	^ aBlock body childSandblocks select: #isExample
]

{ #category : #'as yet unclassified' }
SBExample class >> matches: aMessage [

	^ aMessage receiver isBinding and: [aMessage receiver contents = self name] and: [aMessage selector = 'self:args:label:']
]

{ #category : #'as yet unclassified' }
SBExample class >> newFrom: aMessage [

	^ self new
		self: aMessage arguments first statements first
		args: aMessage arguments second statements first
		label: aMessage arguments third contents
]

{ #category : #'as yet unclassified' }
SBExample class >> self: aBlock args: aCollection [

	" legacy marker, compat "
]

{ #category : #'as yet unclassified' }
SBExample class >> self: aBlock args: aCollection label: aString [

	" marker "
]

{ #category : #'as yet unclassified' }
SBExample >> active [

	^ active
]

{ #category : #'as yet unclassified' }
SBExample >> argumentsBlock [

	^ self submorphs sixth
]

{ #category : #'as yet unclassified' }
SBExample >> artefactSaved: aMethod [

	self active ifTrue: [self run]
]

{ #category : #'as yet unclassified' }
SBExample >> childSandblocksDo: aBlock [

	aBlock value: nameInput.
	aBlock value: self selfBlock.
	aBlock value: self argumentsBlock
]

{ #category : #'as yet unclassified' }
SBExample >> click: anEvent [

	super click: anEvent.
	
	(anEvent yellowButtonPressed and: [lastError notNil]) ifTrue: [ | error |
		"self stopRunning."
		error := lastError.
		self lastError: nil.
		self sandblockEditor reportError: error process: currentProcess; focusErrors.
		"currentProcess debug: error signalerContext title: error asString full: true."]
]

{ #category : #'as yet unclassified' }
SBExample >> codeActions [

	^ super codeActions, {
		(SBCodeAction labeled: 'Debug Example' for: self do: [:node | node debug]).
		(SBCodeAction labeled: 'Show reachability' for: self do: [:node | node showReachability])
	}
]

{ #category : #'as yet unclassified' }
SBExample >> collectTypeInfo [

	| arguments receiver selector |
	receiver := [self evaluateSelf] on: Error do: [^ self].
	arguments := [self evaluateArguments] on: Error do: [^ self].
	selector := self containingArtefact selector asSymbol.
	
	SBTypeCollectSimulator new
		methodMap: self sandblockEditor currentMethodMap;
		simulate: [[receiver perform: selector withArguments: arguments] on: Error do: []]
]

{ #category : #'as yet unclassified' }
SBExample >> currentSelf [

	^ currentSelf
]

{ #category : #'as yet unclassified' }
SBExample >> debug [

	| process |
	process := Process
		forBlock: [self evaluate]
		runUntil: [:context | context method == self containingArtefact compiledMethod].
	
	self sandblockEditor
		reportError: process suspendedContext process: process;
		focusErrors
]

{ #category : #'as yet unclassified' }
SBExample >> doubleClick: anEvent [

	self toggleRunning
]

{ #category : #'as yet unclassified' }
SBExample >> drawnColor [

	^ Color veryDarkGray
]

{ #category : #'as yet unclassified' }
SBExample >> evaluate [

	| arguments |
	currentSelf := self evaluateSelf.
	arguments := self evaluateArguments.
	^ currentSelf perform: self containingArtefact selector asSymbol withArguments: arguments
]

{ #category : #'as yet unclassified' }
SBExample >> evaluateArguments [

	^ self argumentsBlock childSandblocks collect: [:block | Compiler evaluate: block sourceString]
]

{ #category : #'as yet unclassified' }
SBExample >> evaluateSelf [

	^ Compiler evaluate: (SBMessageSend new receiver: self selfBlock veryDeepCopy selector: #value) sourceString
]

{ #category : #'as yet unclassified' }
SBExample >> initialize [

	super initialize.
	
	active := false.
	processRunning := false.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		layoutInset: 8 withScalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellGap: 4 * self scalingFactor
]

{ #category : #'as yet unclassified' }
SBExample >> intoWorld: aWorld [

	super intoWorld: aWorld.
	
	"self startRunning"
]

{ #category : #'as yet unclassified' }
SBExample >> isCurrent [

	^ currentProcess == Processor activeProcess
]

{ #category : #'as yet unclassified' }
SBExample >> isExample [

	^ true
]

{ #category : #'as yet unclassified' }
SBExample >> isMorphExample [

	^ false
]

{ #category : #'as yet unclassified' }
SBExample >> label [

	^ nameInput contents
]

{ #category : #'as yet unclassified' }
SBExample >> lastError: anError [

	lastError := anError.
	(reportedError notNil and: [reportedError expanded not]) ifTrue: [reportedError delete].
	
	anError
		ifNotNil: [
			true ifTrue: [^ reportedError := self sandblockEditor reportError: anError process: ((Process
				forContext: anError signalerContext copyStack
				priority: Processor activeProcess priority)
					shouldResumeFromDebugger: false;
					yourself)"ToolSet debugException: anError"].
			
			errorIndicator ifNil: [self addMorphBack: (errorIndicator := SBIcon iconFlash large; color: Color orange)].
			
			(anError signalerContext
				findContextSuchThat: [:ctx | ctx method = self containingArtefact compiledMethod])
				ifNotNil: [:errorContext |
					(self containingArtefact blockForPC: errorContext previousPc)
						ifNotNil: [:b | b attachDecorator: (errorDecorator := SBErrorDecorator new message: anError asString)]]]
		ifNil: [
			errorIndicator ifNotNil: #delete.
			errorIndicator := nil]
]

{ #category : #'as yet unclassified' }
SBExample >> outOfWorld: aWorld [

	currentProcess ifNotNil: #terminate.
	super outOfWorld: aWorld
]

{ #category : #'as yet unclassified' }
SBExample >> printOn: aStream [

	aStream nextPutAll: 'example'
]

{ #category : #'as yet unclassified' }
SBExample >> run [

	self containingArtefact valid ifFalse: [^ self].
	processRunning ifTrue: [^ self].
	currentProcess ifNotNil: #terminate.
	
	errorDecorator ifNotNil: #detach.
	errorDecorator := nil.
	returnValue clear.
	self sendStartNotification.
	self collectTypeInfo.
	
	processRunning := true.
	currentProcess := [
		| returned |
		[returned := self evaluate] on: Error do: [:e |
			processRunning := false.
			self scheduleLastError: e.
			Processor activeProcess suspend].
		self scheduleLastError: nil.
		currentProcess := nil.
		processRunning := false.
		Project current addDeferredUIMessage: [
			returnValue reportValue: returned."contents: '-> ', returned printString".
			self sendFinishNotification]
	] forkAt: Processor userBackgroundPriority
]

{ #category : #'as yet unclassified' }
SBExample >> scheduleLastError: anError [

	Project current addDeferredUIMessage: [self lastError: anError]
]

{ #category : #'as yet unclassified' }
SBExample >> self: aBlock args: aCollectionBlock label: aString [

	self
		removeAllMorphs;
		addMorphBack: (icon := SBIcon iconPause small; color: Color white);
		addMorphBack: (nameInput := SBTextBubble new contents: aString);
		addMorphBack: (SBStringMorph new contents: 'self:');
		addMorphBack: aBlock;
		addMorphBack: (SBStringMorph new contents: 'args:');
		addMorphBack: aCollectionBlock;
		addMorphBack: (returnValue := SBWatchView new);
		updateIcon
]

{ #category : #'as yet unclassified' }
SBExample >> selfBlock [

	^ self submorphs fourth
]

{ #category : #'as yet unclassified' }
SBExample >> sendFinishNotification [

	self sandblockEditor allMorphsDo: [:morph |
		(morph isSandblock and: [morph isExampleWatch]) ifTrue: [morph exampleFinished: self]]
]

{ #category : #'as yet unclassified' }
SBExample >> sendStartNotification [

	self sandblockEditor allBlocksDo: [:morph |
		morph isExampleWatch ifTrue: [morph exampleStarting: self]]
]

{ #category : #'as yet unclassified' }
SBExample >> showReachability [

	| policy |
	policy := SBReachabilityColorPolicy new.
	SBReachabilitySimulator new
		store: policy;
		simulate: [self evaluate].
	self sandblockEditor colorPolicy: policy
]

{ #category : #'as yet unclassified' }
SBExample >> startRunning [

	"self startSteppingSelector: #run."
	active := true.
	self updateIcon.
	self run
]

{ #category : #'as yet unclassified' }
SBExample >> stepTime [

	^ 2000
]

{ #category : #'as yet unclassified' }
SBExample >> stopRunning [

	self stopSteppingSelector: #run.
	active := false.
	returnValue clear.
	self updateIcon.
	
	self sandblockEditor allMorphsDo: [:morph |
		(morph isSandblock and: [morph isExampleWatch]) ifTrue: [morph exampleStopped: self]]
]

{ #category : #'as yet unclassified' }
SBExample >> toggleRunning [

	self active
		ifFalse: [self startRunning]
		ifTrue: [self stopRunning]
]

{ #category : #'as yet unclassified' }
SBExample >> updateIcon [

	icon changeIconName: (self active
		ifTrue: [#iconPause] ifFalse: [#iconPlay])
]

{ #category : #'as yet unclassified' }
SBExample >> veryDeepCopyWith: aCopier [

	| copy oldError |
	oldError := reportedError.
	reportedError := nil.
	
	copy := super veryDeepCopyWith: aCopier.
	reportedError := oldError.
	
	^ copy
]

{ #category : #'as yet unclassified' }
SBExample >> writeSourceOn: aStream [

	aStream nextPut: $(.
	aStream nextPutAll: self className; space.
	aStream nextPutAll: 'self: ['.
	self selfBlock writeSourceOn: aStream.
	aStream nextPutAll: '] args: ['.
	self argumentsBlock writeSourceOn: aStream.
	aStream nextPutAll: '] label: '''; nextPutAll: nameInput contents; nextPutAll: ''')'
]