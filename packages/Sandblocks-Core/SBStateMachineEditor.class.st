Class {
	#name : #SBStateMachineEditor,
	#superclass : #SBSubstitution,
	#instVars : [
		'connectors',
		'initialState',
		'previous'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBStateMachineEditor class >> matches: aNode [

	(super matches: aNode) ifFalse: [^ false].

	^ aNode isCascade and: [aNode receiver isMessageSend and: [aNode receiver receiver isName and: [aNode receiver receiver contents = 'SBStateMachine' and: [aNode receiver selector = 'new']]]]
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor class >> matchesCascades [

	^ true
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor class >> newFor: aNode [

	^ self new buildFrom: aNode
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> addUponEnter: aBlock [

	self addMorphBack: aBlock
]

{ #category : #initialization }
SBStateMachineEditor >> buildFrom: aNode [

	| states |
	SBExample
		self: [SBStateMachineEditor new]
		args: [
			{
				'TOMStateMachine new
		initialState: #idle;
		
		from: #idle to: #combat if: [ self checkNearbyEnemies ];
		from: #combat to: #idle if: [ self target isNil ];
		from: #combat to: #idle when: #finished' parseAsSandblockWithoutSubstitution
			}]
		label: 'simple'.
	
	states := OrderedDictionary newFrom: (((aNode messages gather: [:message | 
		message selector caseOf: {
			([#from:to:if:] -> [message arguments copyFrom: 1 to: 2]).
			([#from:to:when:] -> [message arguments copyFrom: 1 to: 2]).
			([#from:to:after:] -> [message arguments copyFrom: 1 to: 2]).
			([#initialState:] -> [{message arguments first}]).
			([#uponEnter:do:] -> [{message arguments first}]).
			([#uponLeave:do:] -> [{message arguments first}]).
			([#yourself] -> [{}])
		}]) collect: #contents) withoutDuplicates collect: [:name | name -> (SBStateMachineState new name: name)]).
	states do: [:state | self addMorphBack: state].
	aNode messages do: [:message | 
		message selector caseOf: {
			([#initialState:] -> [initialState := states at: message arguments first contents]).
			([#from:to:if:] -> [ 
				self
					connect: message arguments first contents
					to: message arguments second contents
					if: message arguments third]).
			([#from:to:when:] -> [ 
				self
					connect: message arguments first contents
					to: message arguments second contents
					if: message arguments third]).
			([#from:to:after:] -> [ 
				self
					connect: message arguments first contents
					to: message arguments second contents
					if: message arguments third]).
			([#uponEnter:do:] -> [(states at: message arguments first contents) addUponEnter: message arguments second]).
			([#uponLeave:do:] -> [(states at: message arguments first contents) addUponLeave: message arguments second]).
			([#yourself] -> [nil])
		}].
	self initializePositions
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> canDeleteChild: aBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> checkLowHealth [

	^ 5 < 2
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> checkNearbyEnemies [

	Transcript showln: 'Enemies!'
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> childSandblocksDo: aBlock [

	self states do: [:state | aBlock value: state].
	self connectors do: [:transition | aBlock value: transition conditions]
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> commandPaletteClass [

	^ SBStateMachinePalette
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> connect: aStateName to: anotherStateName if: aBlock [

	| line connectors |
	connectors := self connectors.
	line := connectors
		detect: [:transition |
			transition from name = aStateName and: [transition to name = anotherStateName]]
		ifFound: #yourself
		ifNone: [
			SBStateMachineTransition connect: (self stateNamed: aStateName) to: (self stateNamed: anotherStateName)].
	connectors
		detect: [:transition |
			transition to name = aStateName and: [transition from name = anotherStateName]]
		ifFound: [:transition |
			transition evade: #right.
			line evade: #right].
	line addCondition: aBlock.
	self addMorphBack: line.
	^ line
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> connectors [

	^ self submorphs select: [:morph | morph isKindOf: SBStateMachineTransition]
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> copyExampleStateMachine [

	5 squared.
	[2 squared] value
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> drawnColor [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> example [

	SBMorphExample
		setUp: [
			SBEditor newFor: SBStateMachineEditor >> #exampleStateMachine]
		cases: {
			SBMorphExampleCase name: 'example 1' caseBlock: [:e | e]
		}
		extent: 535 @ 537
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> exampleStateMachine [

	| a b |
	super initialize.
	a := 5.
	
	b := SBStateMachineEditor new
		initialState: #idle;
		uponEnter: #evasion do: [self accelerate];
		uponLeave: #evasion do: [self stop];
		uponEnter: #combat do: [self startShooting];
		uponLeave: #combat do: [self stopShooting];
		from: #idle to: #combat if: [self checkNearbyEnemies];
		from: #idle to: #combat if: [self changed];
		from: #idle to: #combat if: [self checkNearbyEnemies];
		from: #idle to: #combat if: [self changed];
		from: #combat to: #evasion if: [self checkLowHealth];
		from: #evasion to: #idle if: [true];
		from: #combat to: #combat if: [self isMorph]
]

{ #category : #initialization }
SBStateMachineEditor >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> initialState [

	^ initialState
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> initialState: aState [

	previous := initialState.
	initialState := aState.
	aState layoutChanged.
	previous layoutChanged
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> initialize [

	super initialize.
	self extent: 300 @ 300.
	self layoutInset: 6 withScalingFactor.
	self layoutPolicy: nil.
	self vResizing: #shrinkWrap.
	self hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> initializePositions [

	| increment states |
	states := self states.
	increment := 360 / states size.
	states withIndexDo: [:state :index | state position: (Point r: 80 * states size degrees: (increment - 1) * index) + (self extent / 2)]
]

{ #category : #initialization }
SBStateMachineEditor >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		index: self submorphCount + 1;
		container: self;
		morph: (SBStateMachineState new name: 'unnamed'; position: self position + (30 @ 30));
		yourself
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> minExtent [

	| area |
	area := Rectangle merging: self submorphs.
	^ area extent + (area origin - self position)
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> stateNamed: aName [

	^ self states detect: [:s | s name = aName]
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> states [

	^ self submorphs select: [:morph | morph isKindOf: SBStateMachineState]
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> writeSourceOn: aStream [

	SBExample
		self: [SBStateMachineEditor new buildFrom: 'SBStateMachine new
		initialState: #idle;
		
		uponEnter: #combat do: [ self combat ];
		from: #idle to: #combat if: [ self checkNearbyEnemies ];
		from: #combat to: #idle if: [ self target isNil ]' parseAsSandblockWithoutSubstitution]
		args: [{'' writeStream}]
		label: 'simple'.
	aStream
		nextPut: $(;
		nextPutAll: 'SBStateMachine';
		nextPutAll: ' new';
		nextPutAll: ' initialState: ';
		nextPutAll: self initialState name asSymbol storeString.
	self states do: [:state | 
		state uponEnterBlocks do: [:block | 
			aStream nextPut: $;.
			aStream nextPutAll: 'uponEnter: '.
			state name asSymbol storeOn: aStream.
			aStream nextPutAll: ' do: '.
			block writeSourceOn: aStream].
		state uponLeaveBlocks do: [:block | 
			aStream nextPut: $;.
			aStream nextPutAll: 'uponLeave: '.
			state name asSymbol storeOn: aStream.
			aStream nextPutAll: ' do: '.
			block writeSourceOn: aStream]].
	self connectors do: [:transition | 
		transition conditions do: [:condition | 
			aStream nextPut: $;.
			aStream nextPutAll: 'from: '.
			transition from name asSymbol storeOn: aStream.
			aStream nextPutAll: ' to: '.
			transition to name asSymbol storeOn: aStream.
			SBToggledCode
				comment: 'is a duration'
				active: 1
				do: {[condition isMessageSend ifTrue: [aStream nextPutAll: ' after: ']]}.
			SBToggledCode
				comment: 'condition evaluated at each tick'
				active: 1
				do: {[condition isBlockBody ifTrue: [aStream nextPutAll: ' if: ']]}.
			SBToggledCode
				comment: 'is a trigger symbol'
				active: 1
				do: {[condition isSymbolBlock ifTrue: [aStream nextPutAll: ' when: ']]}.
			condition writeSourceOn: aStream]].
	aStream nextPut: $)
]
