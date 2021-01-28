"
A TOMStateMachine is a versatile implementation of a state machine, providing event based, condition based and time based triggers.
"
Class {
	#name : #SBStateMachine,
	#superclass : #Object,
	#instVars : [
		'conditionalTransitions',
		'signalTransitions',
		'enterActions',
		'leaveActions',
		'state',
		'timeTransitions'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #private }
SBStateMachine >> ensureTriggerListsFor: aState [

	signalTransitions at: aState ifAbsentPut: [Dictionary new].
	conditionalTransitions at: aState ifAbsentPut: [Dictionary new].
	timeTransitions at: aState ifAbsentPut: [Dictionary new].
	leaveActions at: aState ifAbsentPut: [OrderedCollection new].
	enterActions at: aState ifAbsentPut: [OrderedCollection new]
]

{ #category : #transitions }
SBStateMachine >> from: startState to: endState after: aDuration [
	" transition after spending `aDuration` in startState "
	(timeTransitions at: startState ifAbsentPut: [ Dictionary new ])
		at: endState
		put: {aDuration. aDuration}
]

{ #category : #transitions }
SBStateMachine >> from: startState to: endState if: aBlock [
	" transition when aBlock becomes true "
	(conditionalTransitions at: startState ifAbsentPut: [ Dictionary new ])
		at: aBlock
		put: endState
]

{ #category : #transitions }
SBStateMachine >> from: startState to: endState when: aSignal [
	" transition upon receiving a signal "
	(signalTransitions at: startState ifAbsentPut: [ Dictionary new ])
		at: aSignal
		put: endState
]

{ #category : #transitions }
SBStateMachine >> fromAll: startStates to: endState after: aDuration [
	startStates do: [ :startState | self from: startState to: endState after: aDuration ]
]

{ #category : #transitions }
SBStateMachine >> fromAll: startStates to: endState if: aBlock [
	startStates do: [ :startState | self from: startState to: endState if: aBlock ]
]

{ #category : #transitions }
SBStateMachine >> fromAll: startStates to: endState when: aSignal [
	startStates do: [ :startState | self from: startState to: endState when: aSignal ]
]

{ #category : #initialization }
SBStateMachine >> initialState: aState [

	self ensureTriggerListsFor: aState.
	self state: aState
]

{ #category : #transitions }
SBStateMachine >> initialize [
	super initialize.
	
	signalTransitions := Dictionary new.
	conditionalTransitions := Dictionary new.
	timeTransitions := Dictionary new.
	
	enterActions := Dictionary new.
	leaveActions := Dictionary new
]

{ #category : #accessing }
SBStateMachine >> performEnterActionsFor: aState leaving: anotherState [

	(enterActions at: aState) do: [ :action | action valueWithEnoughArguments: {anotherState} ]
]

{ #category : #private }
SBStateMachine >> resetTimeTransitionsFor: aState [
	(timeTransitions at: aState) keysAndValuesDo: [ :endState :time |
		time at: 1 put: time second ]
]

{ #category : #transitions }
SBStateMachine >> start [

	state ifNil: [self error: 'no initial state configured'].
	
	self performEnterActionsFor: state leaving: nil
]

{ #category : #accessing }
SBStateMachine >> state [
	^state
]

{ #category : #accessing }
SBStateMachine >> state: newState [

	| oldState |
	oldState := self state.
	oldState ifNotNil: [(leaveActions at: oldState) do: [:action | action valueWithEnoughArguments: newState]].
	
	state := newState.
	self ensureTriggerListsFor: newState.
	self resetTimeTransitionsFor: newState.
	
	self performEnterActionsFor: state leaving: oldState
]

{ #category : #transitions }
SBStateMachine >> tick: dt [

	| passedDuration |
	passedDuration := dt seconds.
	
	(conditionalTransitions at: self state) keysAndValuesDo: [:conditionalBlock :endState | conditionalBlock value ifTrue: [^ self state: endState]].
	
	(timeTransitions at: self state) keysAndValuesDo: [:endState :time |
		time at: 1 put: time first - passedDuration.
		time first negative ifTrue: [^ self state: endState]]
]

{ #category : #transitions }
SBStateMachine >> trigger: aSignal [
	(signalTransitions at: self state) at: aSignal ifPresent: [ :endState |
		self state: endState ]
]

{ #category : #transitions }
SBStateMachine >> uponEnter: aState do: aBlock [
	(enterActions at: aState ifAbsentPut: [ OrderedCollection new ]) add: aBlock
]

{ #category : #transitions }
SBStateMachine >> uponLeave: aState do: aBlock [
	(leaveActions at: aState ifAbsentPut: [ OrderedCollection new ]) add: aBlock
]
