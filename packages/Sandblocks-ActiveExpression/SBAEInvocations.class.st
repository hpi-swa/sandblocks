"
A SBAEInvocations holds all active expressions and the list of their activations. It displays the invocations of one active expression that is currently focused, as well as your some tooling to further inspect the active expression's invocations.
"
Class {
	#name : #SBAEInvocations,
	#superclass : #Morph,
	#instVars : [
		'invocations',
		'expressionIndex',
		'expressions',
		'marble'
	],
	#category : #'Sandblocks-ActiveExpression'
}

{ #category : #accessing }
SBAEInvocations >> addExpression: anObject [

	expressions at: anObject put: OrderedCollection new.
	self update
]

{ #category : #helper }
SBAEInvocations >> addInvocation: anInvocation toList: aCollection [

	aCollection addFirst: anInvocation.
	self updateInterestingCodeLocations: aCollection
]

{ #category : #accessing }
SBAEInvocations >> addInvocation: aContext value: anObject from: aSubjectObject expression: anAExpression [

	| stack newInvocation |
	stack := self relevantContextsFrom: thisContext.
	newInvocation := SBAEInvocationAggregate new.
	
	" defer because we can come here from the simulator, making this very slow "
	Project current addDeferredUIMessage: [ | index |
		newInvocation
			 stack: stack;
			 addInvocation: anObject asString;
			 subject: aSubjectObject.
		invocations addMorph: newInvocation.
		
		index := expressions keysInOrder indexOf: anAExpression.
		self
			addInvocation: newInvocation toList: (expressions atIndex: index) value;
			expressionIndex: index].
	
	^ newInvocation
]

{ #category : #helper }
SBAEInvocations >> addInvocationToList: anInvocation [

	(expressions at: anInvocation expression) addFirst: anInvocation
]

{ #category : #accessing }
SBAEInvocations >> currentExpression [

	^ (expressions atIndex: self expressionIndex) key
]

{ #category : #'example callbacks' }
SBAEInvocations >> exampleFinished: anExample [

	
]

{ #category : #'example callbacks' }
SBAEInvocations >> exampleStarting: anExample [

	invocations removeAllMorphs; extent: 0 @ 0.
	expressions removeAll.
	self update
]

{ #category : #callbacks }
SBAEInvocations >> exploreSubject [

	self currentExpression subject explore
]

{ #category : #accessing }
SBAEInvocations >> expressionIndex [

	^ expressionIndex value
]

{ #category : #accessing }
SBAEInvocations >> expressionIndex: aNumber [
	" index into our OrderedDictionary of the currently displayed active expression "

	expressionIndex = aNumber ifTrue: [^ self].
	
	invocations removeAllMorphs.
	invocations addAllMorphs: (expressions atIndex: aNumber) value.
	expressionIndex value: aNumber.
	marble
		subject: self currentExpression subject;
		value: self currentExpression lastValue
]

{ #category : #callbacks }
SBAEInvocations >> filterMorph [

	| pos morphs morph |
	pos := Point fromUser.
	morphs := (self world morphsAt: pos) select: [:m | expressions keys anySatisfy: [:exp | exp subject = m]].
	morphs ifEmpty: [^ UIManager default inform: 'Morph does not have an active expression'].
	morph := morphs size > 1 ifTrue: [morphs at: ((UIManager default chooseFrom: morphs) ifNil: [^ self])] ifFalse: [morphs first].
	self selectExpression: (expressions keys detect: [:expression | expression subject = morph])
]

{ #category : #initialization }
SBAEInvocations >> initialize [

	super initialize.
	
	expressions := OrderedDictionary new.
	
	self
		color: Color transparent;
		layoutPolicy: SBVerticalLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		extent: 0 @ 0;
		color: Color transparent;
		changeTableLayout;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap;
		listDirection: #topToBottom;
		cellPositioning: #topLeft;
		cellGap: 4 withScalingFactor;
		addMorphBack: (SBRow new
			cellGap: 8 withScalingFactor;
			addMorphBack: (marble := SBMarble new);
			addMorphBack: (expressionIndex := SBConstrainedNumberInput new
				color: Color white;
				value: 1;
				min: 1;
				onChange: [:num | self expressionIndex: num];
				yourself);
			addMorphBack: (SBIcon iconCrosshairs
				on: #click send: #filterMorph to: self;
				balloonText: 'Pick Morph';
				yourself);
			addMorphBack: (SBIcon iconAnchor
				on: #click send: #showDependencies to: self;
				balloonText: 'Show Dependencies';
				yourself);
			addMorphBack: (SBIcon iconShare
				on: #click send: #showSubscribers to: self;
				balloonText: 'Show Subscribers';
				yourself);
			addMorphBack: (SBIcon iconSearch
				on: #click send: #exploreSubject to: self;
				balloonText: 'Explore Subject';
				yourself);
			yourself);
		addMorphBack: (invocations := SBColum new)
]

{ #category : #helper }
SBAEInvocations >> relevantContextsFrom: aContext [

	| sendingContext res max |
	sendingContext := (aContext findContextSuchThat: [:context |
		context receiver = VarTra and:
		[context selector =  #notify:instVarNamed:ofObject:changedFrom:to:inContext:]
		and: [context isMethodContext]]) ifNotNil: #sender ifNil: [^ aContext stack].
	
	max := 10.
	res := Array streamContents: [:stream  | | ctx |
		stream nextPut: (SBCodeContext for: (ctx := sendingContext)).
		" go up all the way or until one of our entrypoints is found. inlined for performance "
		[(ctx := ctx sender) ~~ nil and: [ctx selector ~= #run and: [ctx receiver class ~= SBExample]]]
			whileTrue: [
				max := max - 1.
				stream nextPut: ((SBCodeContext for: ctx) pc: ctx previousPc)]].
	
	self flag: #fixme. " the first invocation had the generated AE check code before its actual invocation. maybe we can find a more robust way to adjust this? "
	res ifNotEmpty: [res first pc: (res first method pcOfReceiverAssignmentBefore: res first pc)].
	^ res
]

{ #category : #callbacks }
SBAEInvocations >> selectExpression: anExpression [

	self expressionIndex: (expressions keysInOrder indexOf: anExpression)
]

{ #category : #callbacks }
SBAEInvocations >> selectSubject: anObject [

	self expressionIndex: (expressions keysInOrder findFirst: [:expression | expression subject = anObject])
]

{ #category : #callbacks }
SBAEInvocations >> showDependencies [

	self currentExpression simulateMonitoredBlock ifNotNil: [:simulation |
		({'Literal Variables:'}, (simulation litVarAccesses ifEmpty: [{'---'}]),
		{'Instance Variables:'}, (simulation instVarAccesses associations
			collect: [:assoc | assoc key -> (assoc value collect: [:index | assoc key class instVarNameForIndex: index + 1])]),
		{'Temporary Variables:'}, (simulation tempVarAccesses ifEmpty: [{'---'}])) explore]
]

{ #category : #callbacks }
SBAEInvocations >> showSubscribers [

	self triggerEvent: #showSubscribers with: self currentExpression
]

{ #category : #helper }
SBAEInvocations >> update [

	expressionIndex max: expressions size
]

{ #category : #helper }
SBAEInvocations >> updateInterestingCodeLocations: aCollection [

	" walk up from each tracked invocation and find the first point where all differ "
	| index |
	aCollection size < 2 ifTrue: [^ self].
	
	index := 1.
	[ 
		((aCollection anySatisfy: [:invocation | invocation stack size >= index]) or: [(aCollection collect: [:invocation | invocation stack at: index] as: Set) size > 1]) ifTrue: [
			aCollection do: [:invocation | invocation stackImageIndex: index].
			^ self].
		index := index + 1
	] repeat
]
