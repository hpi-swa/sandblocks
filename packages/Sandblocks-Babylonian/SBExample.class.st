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
		'reportedError',
		'traceSize'
	],
	#category : #'Sandblocks-Babylonian'
}

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

{ #category : #constants }
SBExample class >> matchingSelectors [

	^ #(#self:args:label: #self:args:label:assert: #example:args:label: #example:args:label:assert:)
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

	aProvider registerShortcut: $w command do: #wrapWithExampleWatch
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

{ #category : #accessing }
SBExample >> active [

	^ active
]

{ #category : #actions }
SBExample >> addAssertion [
	<action>

	
	self addAssertion: self newNullBlock
]

{ #category : #layout }
SBExample >> addAssertion: aBlock [

	self addMorphBack: (SBStringMorph new contents: 'assert:').
	^ self addMorphBack: aBlock
]

{ #category : #accessing }
SBExample >> argumentsBlock [

	^ self submorphs sixth
]

{ #category : #callbacks }
SBExample >> artefactSaved: aMethod [

	(aMethod isMethod and: [self active]) ifTrue: [self run]
]

{ #category : #accessing }
SBExample >> assertionBlock [

	^ self submorphCount > 7 ifTrue: [self submorphs ninth] ifFalse: [nil]
]

{ #category : #'event handling' }
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

{ #category : #accessing }
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

{ #category : #accessing }
SBExample >> currentMethodMap [

	^ (self sandblockEditor methods select: #exists) collect: [:method | method compiledMethod sandblocksFastHash -> method] as: Dictionary
]

{ #category : #accessing }
SBExample >> currentSelf [

	^ currentSelf
]

{ #category : #actions }
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

{ #category : #'event handling' }
SBExample >> doubleClick: anEvent [

	self toggleRunning
]

{ #category : #'colors and color policies' }
SBExample >> drawnColor [

	^ self colorPolicy toolColorFor: self
]

{ #category : #evaluate }
SBExample >> evaluate [

	| arguments |
	currentSelf := self evaluateSelf.
	arguments := self evaluateArguments.
	^ currentSelf perform: self containingArtefact selector asSymbol withArguments: arguments
]

{ #category : #evaluate }
SBExample >> evaluateArguments [

	^ self argumentsBlock childSandblocks collect: [:block | Compiler evaluate: block sourceString]
]

{ #category : #evaluate }
SBExample >> evaluateIn: aBlock [

	| arguments |
	currentSelf := self evaluateSelf.
	arguments := self evaluateArguments.
	^ aBlock value: [currentSelf perform: self containingArtefact selector asSymbol withArguments: arguments]
]

{ #category : #evaluate }
SBExample >> evaluateSelf [

	^ Compiler evaluate: self selfBlock veryDeepCopy sourceString
]

{ #category : #execution }
SBExample >> execute [

	| newSelf arguments |
	newSelf := self evaluateSelf.
	arguments := self evaluateArguments.
	^ newSelf perform: self containingArtefact selector asSymbol withArguments: arguments
]

{ #category : #execution }
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

{ #category : #initialization }
SBExample >> initialize [

	super initialize.
	
	active := false.
	processRunning := false.
	traceSize := 0.
	
	self
		layoutInset: 8;
		changeTableLayout;
		listDirection: #leftToRight;
		cellPositioning: #center;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellGap: 4 * self scalingFactor
]

{ #category : #initialization }
SBExample >> intoWorld: aWorld [

	super intoWorld: aWorld.
	
	"self startRunning"
]

{ #category : #accessing }
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

{ #category : #accessing }
SBExample >> label [

	^ nameInput contents
]

{ #category : #accessing }
SBExample >> lastError: anError [

	lastError := anError.
	(reportedError notNil and: [reportedError expanded not]) ifTrue: [reportedError delete].
	
	anError
		ifNotNil: [
			true ifTrue: [
				"ToolSet debugException: anError"
				^ reportedError := self sandblockEditor
					reportError: anError
					process: ((Process forContext: anError signal copyStack priority: Processor activeProcess priority)
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

{ #category : #layout }
SBExample >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs pairsCollect: [:a :b |
			SBAlgebraCommand group data: {a layoutCommands. SBAlgebraCommand gap. b layoutCommands. SBAlgebraCommand softLineOrGap}]), {self lastSubmorph layoutCommands}
]

{ #category : #accessing }
SBExample >> nameBlock [

	^ self submorphs second
]

{ #category : #initialization }
SBExample >> outOfWorld: aWorld [

	currentProcess ifNotNil: #terminate.
	super outOfWorld: aWorld
]

{ #category : #printing }
SBExample >> printOn: aStream [

	aStream nextPutAll: 'example'
]

{ #category : #testing }
SBExample >> providesExecutionEnvironment [

	^ true
]

{ #category : #accessing }
SBExample >> registerWatchValue [

	traceSize := traceSize + 1
]

{ #category : #execution }
SBExample >> run [

	self runSetup.
	self sendStartNotification.
	
	processRunning := true.
	currentProcess := [ | returned |
		SBExecutionEnvironment value: self.
		
		[returned := self evaluate] on: Error do: [:e |
			processRunning := false.
			self scheduleLastError: e.
			Processor activeProcess suspend].
		self scheduleLastError: nil.
		currentProcess := nil.
		processRunning := false.
		SBVariant
			named: 'addDeferredUIMessage:'
			associations: {
				'with' -> [
					Project current addDeferredUIMessage: [
						returnValue reportValues: {returned asSBWatchValue} sized: SBMorphResizer newThumbmail.
						returnValue updateDisplay.
						self sendFinishNotification]].
				'without' -> [Project current addDeferredUIMessage: [self sendFinishNotification]]}
			activeIndex: 2
			id: '60c08640-321a-fb4c-90f8-8d2bd5ab0bcc'
			isActive: false] forkAt: Processor userBackgroundPriority.
	
	^ currentProcess
]

{ #category : #actions }
SBExample >> runOnlyThis [
	<action>
	
	self sandblockEditor allBlocksDo: [:block | (block isExample and: [block ~= self]) ifTrue: [block stopRunning]].
	self startRunning
]

{ #category : #execution }
SBExample >> runSetup [

	self containingArtefact valid ifFalse: [^ self].
	processRunning ifTrue: [^ self].
	currentProcess ifNotNil: #terminate.
	
	errorDecorator ifNotNil: #detach.
	errorDecorator := nil.
	traceSize := 0.
	SBVariant
		named: 'clear'
		associations: {'with' -> [returnValue clear]. 'without' -> []}
		activeIndex: 2
		id: '62643a5a-1d80-7f43-a32f-f23665e98f83'
		isActive: false
]

{ #category : #execution }
SBExample >> runSynchUpdatingOnlyValuesOf: aCollectionOfSBWatches [

	| returned |
	aCollectionOfSBWatches do: [:aWatch | aWatch resetOnlyValuesFor: self].
	traceSize := 0.
	SBExecutionEnvironment value: self.
	[returned := self evaluate] on: Error do: [:e | self scheduleLastError: e].
	self scheduleLastError: nil.
	aCollectionOfSBWatches do: [:aWatch | aWatch exampleFinished: self]
	
]

{ #category : #execution }
SBExample >> scheduleLastError: anError [

	Project current addDeferredUIMessage: [self lastError: anError]
]

{ #category : #initialization }
SBExample >> self: aBlock args: aCollectionBlock label: aString [

	SBVariant
		named: 'remove returnValue'
		associations: {
			'with' -> [
				self
					removeAllMorphs;
					addMorphBack: (icon := SBIcon iconPause
						small;
						color: (Color r: 1 g: 1 b: 1);
						on: #click send: #toggleRunning to: self);
					addMorphBack: (nameInput := SBTextBubble new contents: aString);
					addMorphBack: (SBStringMorph new contents: 'self:');
					addMorphBack: aBlock;
					addMorphBack: (SBStringMorph new contents: 'args:');
					addMorphBack: aCollectionBlock;
					addMorphBack: (returnValue := SBExampleWatchView new);
					updateIcon].
			'w/o' -> [
				self
					removeAllMorphs;
					addMorphBack: (icon := SBIcon iconPause
						small;
						color: (Color r: 1 g: 1 b: 1);
						on: #click send: #toggleRunning to: self);
					addMorphBack: (nameInput := SBTextBubble new contents: aString);
					addMorphBack: (SBStringMorph new contents: 'self:');
					addMorphBack: aBlock;
					addMorphBack: (SBStringMorph new contents: 'args:');
					addMorphBack: aCollectionBlock;
					updateIcon]}
		activeIndex: 2
		id: '769c6446-2026-6547-a0ff-101e54bf3665'
		isActive: false
]

{ #category : #initialization }
SBExample >> self: aBlock args: aCollectionBlock label: aString assert: anAssertBlock [

	self self: aBlock args: aCollectionBlock label: aString.
	self addAssertion: anAssertBlock
]

{ #category : #accessing }
SBExample >> selfBlock [

	^ self submorphs fourth
]

{ #category : #execution }
SBExample >> sendFinishNotification [

	self sandblockEditor allMorphsDo: [:morph |
		(morph isSandblock and: [morph listensToExamples]) ifTrue: [morph exampleFinished: self]]
]

{ #category : #execution }
SBExample >> sendStartNotification [

	self sandblockEditor allBlocksDo: [:morph |
		morph listensToExamples ifTrue: [morph exampleStarting: self]]
]

{ #category : #actions }
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

{ #category : #execution }
SBExample >> startRunning [

	active ifTrue: [^ self].
	
	active := true.
	self updateIcon.
	self run
]

{ #category : #'stepping and presenter' }
SBExample >> stepTime [

	^ 2000
]

{ #category : #execution }
SBExample >> stopRunning [

	active ifFalse: [^ false].
	
	self stopSteppingSelector: #run.
	active := false.
	SBVariant
		named: 'clear'
		associations: {'with' -> [returnValue clear]. 'without' -> []}
		activeIndex: 2
		id: 'f319a83a-f7aa-9a40-b959-f56ad3c4cfbc'
		isActive: false.
	self updateIcon.
	
	self sandblockEditor allMorphsDo: [:morph | (morph isSandblock and: [morph listensToExamples]) ifTrue: [morph exampleStopped: self]]
]

{ #category : #actions }
SBExample >> toggleRunning [
	<action>

	self active
		ifFalse: [self startRunning]
		ifTrue: [self stopRunning]
]

{ #category : #accessing }
SBExample >> traceSize [

	^ traceSize
]

{ #category : #layout }
SBExample >> updateIcon [

	icon changeIconName: (self active
		ifTrue: [#iconPause] ifFalse: [#iconPlay])
]

{ #category : #copying }
SBExample >> veryDeepCopyWith: aCopier [

	| copy oldError |
	oldError := reportedError.
	reportedError := nil.
	
	copy := super veryDeepCopyWith: aCopier.
	reportedError := oldError.
	
	^ copy
]

{ #category : #printing }
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
