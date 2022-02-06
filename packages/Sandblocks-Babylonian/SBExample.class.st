Class {
	#name : #SBExample,
	#superclass : #SBStSubstitution,
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
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'as yet unclassified' }
SBExample class >> getAllInMethod: aBlock [

	^ aBlock body childSandblocks select: #isExample
]

{ #category : #'as yet unclassified' }
SBExample class >> instanceSuggestion [

	^ [
		self new
			self: SBStGrammarHandler new newNullBlock
			args: (SBStArray new type: #dynamic)
			label: 'example']
]

{ #category : #'as yet unclassified' }
SBExample class >> matches: aMessage [

	(super matches: aMessage) ifFalse: [^ false].
	
	^ ((aMessage receiver satisfies: #(#notNil #isBinding))
		and: [aMessage receiver contents = self name]
		and: [#('self:args:label:' 'self:args:label:assert:') includes: aMessage selector]) or: [
		(aMessage receiver satisfies: #(#notNil #isName))
			and: [aMessage receiver contents = 'self']
			and: [#('example:args:label:' 'example:args:label:assert:') includes: aMessage selector]]
]

{ #category : #'as yet unclassified' }
SBExample class >> newFor: aMessage [

	^ aMessage arguments size = 4
		ifTrue: [
			self new
				self: aMessage arguments first statements first
				args: aMessage arguments second statements first
				label: aMessage arguments third contents
				assert: aMessage arguments fourth statements first]
		ifFalse: [
			self new
				self: aMessage arguments first statements first
				args: aMessage arguments second statements first
				label: aMessage arguments third contents]
]

{ #category : #'as yet unclassified' }
SBExample class >> registerShortcuts: aProvider [

	aProvider registerShortcut: $q command do: #wrapWithExampleWatch
]

{ #category : #'as yet unclassified' }
SBExample class >> self: aBlock args: aCollection [

	" legacy marker, compat "
]

{ #category : #'as yet unclassified' }
SBExample class >> self: aBlock args: aCollection label: aString [
	
]

{ #category : #'as yet unclassified' }
SBExample class >> self: aBlock args: aCollection label: aString assert: anAssertBlock [

	
]

{ #category : #'as yet unclassified' }
SBExample >> active [

	^ active
]

{ #category : #'as yet unclassified' }
SBExample >> addAssertion [
	<action>

	
	self addAssertion: self newNullBlock
]

{ #category : #'as yet unclassified' }
SBExample >> addAssertion: aBlock [

	self addMorphBack: (SBStringMorph new contents: 'assert:').
	^ self addMorphBack: aBlock
]

{ #category : #'as yet unclassified' }
SBExample >> argumentsBlock [

	^ self submorphs sixth
]

{ #category : #'as yet unclassified' }
SBExample >> artefactSaved: aMethod [

	(aMethod isMethod and: [self active]) ifTrue: [self run]
]

{ #category : #'as yet unclassified' }
SBExample >> assertionBlock [

	^ self submorphCount > 7 ifTrue: [self submorphs ninth] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBExample >> click: anEvent [

	super click: anEvent.
	
	(anEvent yellowButtonPressed and: [lastError notNil]) ifTrue: [ | error |
		"self stopRunning."
		error := lastError.
		self lastError: nil.
		self sandblockEditor
			reportError: error process: currentProcess source: self;
			focusErrors
		"currentProcess debug: error signalerContext title: error asString full: true."]
]

{ #category : #'as yet unclassified' }
SBExample >> collectTypeInfo [

	| arguments receiver selector |
	receiver := [self evaluateSelf] on: Error do: [^ self].
	arguments := [self evaluateArguments] on: Error do: [^ self].
	selector := self containingArtefact selector asSymbol.
	
	self containingArtefact arguments
		with: arguments
		do: [:arg :obj | self containingArtefact cacheType: obj class for: arg].
	
	Smalltalk at: #SBTypeCollectSimulator ifPresent: [:typeCollectorClass |
		typeCollectorClass new
			methodMap: self currentMethodMap;
			runSimulated: [
				[receiver perform: selector withArguments: arguments]
					on: Error
					do: []]]
]

{ #category : #'as yet unclassified' }
SBExample >> currentMethodMap [

	^ (self sandblockEditor methods select: #exists) collect: [:method | method compiledMethod sandblocksFastHash -> method] as: Dictionary
]

{ #category : #'as yet unclassified' }
SBExample >> currentSelf [

	^ currentSelf
]

{ #category : #'as yet unclassified' }
SBExample >> debug [
	<action>

	| process startMethod currentSelf arguments selector |
	startMethod := self containingArtefact compiledMethod.
	currentSelf := self evaluateSelf.
	arguments := self evaluateArguments.
	selector := self containingArtefact selector asSymbol.
	
	process := Process
		forBlock: [currentSelf perform: selector withArguments: arguments]
		runUntil: [:context | context method == startMethod].
	self sandblockEditor reportError: Halt new process: process source: self.
	self sandblockEditor errors focusErrors
]

{ #category : #'as yet unclassified' }
SBExample >> doubleClick: anEvent [

	self toggleRunning
]

{ #category : #'as yet unclassified' }
SBExample >> drawnColor [

	^ self colorPolicy toolColorFor: self
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
SBExample >> evaluateIn: aBlock [

	| arguments |
	currentSelf := self evaluateSelf.
	arguments := self evaluateArguments.
	^ aBlock value: [currentSelf perform: self containingArtefact selector asSymbol withArguments: arguments]
]

{ #category : #'as yet unclassified' }
SBExample >> evaluateSelf [

	^ Compiler evaluate: self selfBlock veryDeepCopy sourceString
]

{ #category : #'as yet unclassified' }
SBExample >> execute [

	| newSelf arguments |
	newSelf := self evaluateSelf.
	arguments := self evaluateArguments.
	^ newSelf perform: self containingArtefact selector asSymbol withArguments: arguments
]

{ #category : #'as yet unclassified' }
SBExample >> executeForBlock: aBlock ifFound: aClosure [

	[ | newSelf arguments |
		newSelf := self evaluateSelf.
		arguments := self evaluateArguments.
		(Smalltalk at: #SBStRunUntilSandbox) new
			selector: aBlock containingArtefact selector;
			receiverClass: aBlock containingArtefact methodClass;
			stepLimit: 5000;
			pc: aBlock pc;
			evaluate: [newSelf perform: self containingArtefact selector asSymbol withArguments: arguments]]
		on: SBStRunUntilValue
		do: [:val | aClosure value: val value]
		on: SandboxError
		do: [:err | SBWatch report: err for: 477523582]
]

{ #category : #'as yet unclassified' }
SBExample >> initialize [

	super initialize.
	
	active := false.
	processRunning := false.
	
	self
		layoutInset: 8;
		changeTableLayout;
		listDirection: #leftToRight;
		cellPositioning: #center;
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
			true ifTrue: [
				"ToolSet debugException: anError"
				^ reportedError := self sandblockEditor
					reportError: anError
					process: ((Process forContext: anError signalerContext copyStack priority: Processor activeProcess priority)
						shouldResumeFromDebugger: false;
						yourself)
					source: self].
			
			errorIndicator ifNil: [
				self addMorphBack: (errorIndicator := SBIcon iconFlash
					large;
					color: (Color r: 1 g: 0.6 b: 0.0))].
			
			(anError signalerContext findContextSuchThat: [:ctx | ctx method = self containingArtefact compiledMethod]) ifNotNil: [:errorContext | (self containingArtefact blockForPC: errorContext previousPc) ifNotNil: [:b | b attachDecorator: (errorDecorator := SBErrorDecorator new message: anError asString)]]]
		ifNil: [
			errorIndicator ifNotNil: #delete.
			errorIndicator := nil]
]

{ #category : #'as yet unclassified' }
SBExample >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs pairsCollect: [:a :b |
			SBAlgebraCommand group data: {a layoutCommands. SBAlgebraCommand gap. b layoutCommands. SBAlgebraCommand softLineOrGap}]), {self lastSubmorph layoutCommands}
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
SBExample >> providesExecutionEnvironment [

	^ true
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
	"self collectTypeInfo."
	
	processRunning := true.
	currentProcess := [
		| returned |
		SBExecutionEnvironment value: self.
		
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
SBExample >> runOnlyThis [
	<action>
	
	self sandblockEditor allBlocksDo: [:block | (block isExample and: [block ~= self]) ifTrue: [block stopRunning]].
	self startRunning
]

{ #category : #'as yet unclassified' }
SBExample >> scheduleLastError: anError [

	Project current addDeferredUIMessage: [self lastError: anError]
]

{ #category : #'as yet unclassified' }
SBExample >> self: aBlock args: aCollectionBlock label: aString [

	self
		removeAllMorphs;
		addMorphBack: (icon := SBIcon iconPause
			small;
			color: Color white;
			on: #click send: #toggleRunning to: self);
		addMorphBack: (nameInput := SBTextBubble new contents: aString);
		addMorphBack: (SBStringMorph new contents: 'self:');
		addMorphBack: aBlock;
		addMorphBack: (SBStringMorph new contents: 'args:');
		addMorphBack: aCollectionBlock;
		addMorphBack: (returnValue := SBWatchView new);
		updateIcon
]

{ #category : #'as yet unclassified' }
SBExample >> self: aBlock args: aCollectionBlock label: aString assert: anAssertBlock [

	self self: aBlock args: aCollectionBlock label: aString.
	self addAssertion: anAssertBlock
]

{ #category : #'as yet unclassified' }
SBExample >> selfBlock [

	^ self submorphs fourth
]

{ #category : #'as yet unclassified' }
SBExample >> sendFinishNotification [

	self sandblockEditor allMorphsDo: [:morph |
		(morph isSandblock and: [morph listensToExamples]) ifTrue: [morph exampleFinished: self]]
]

{ #category : #'as yet unclassified' }
SBExample >> sendStartNotification [

	self sandblockEditor allBlocksDo: [:morph |
		morph listensToExamples ifTrue: [morph exampleStarting: self]]
]

{ #category : #'as yet unclassified' }
SBExample >> showReachability [
	<action>

	| policy |
	policy := SBReachabilityColorPolicy new.
	self evaluateIn: [:exec |
		SBStReachabilitySimulator new
			store: policy;
			runSimulated: exec].
	self sandblockEditor colorPolicy: policy
]

{ #category : #'as yet unclassified' }
SBExample >> startRunning [

	active ifTrue: [^ self].
	
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

	active ifFalse: [^ false].
	
	self stopSteppingSelector: #run.
	active := false.
	returnValue clear.
	self updateIcon.
	
	self sandblockEditor allMorphsDo: [:morph |
		(morph isSandblock and: [morph listensToExamples]) ifTrue: [morph exampleStopped: self]]
]

{ #category : #'as yet unclassified' }
SBExample >> toggleRunning [
	<action>

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
	aStream
		nextPutAll: 'self';
		space.
	aStream nextPutAll: 'example: ['.
	self selfBlock writeSourceOn: aStream.
	aStream nextPutAll: '] args: ['.
	self argumentsBlock writeSourceOn: aStream.
	aStream
		nextPutAll: '] label: ''';
		nextPutAll: nameInput contents;
		nextPut: $'.
	
	self assertionBlock ifNotNil: [:block |
		aStream nextPutAll: ' assert: ['.
		block writeSourceOn: aStream.
		aStream nextPut: $]].
	
	aStream nextPut: $)
]
