Class {
	#name : #SBStateMachine,
	#superclass : #SBSubstitution,
	#instVars : [
		'states',
		'connectors',
		'initialState',
		'previous'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBStateMachine class >> matches: aNode [

	^ aNode isCascade and: [aNode receiver isMessageSend and: [aNode receiver receiver isName and: [aNode receiver receiver contents = 'SBStateMachine' and: [aNode receiver selector = 'new']]]]
]

{ #category : #'as yet unclassified' }
SBStateMachine class >> matchesCascades [

	^ true
]

{ #category : #'instance creation' }
SBStateMachine class >> newFrom: aNode [ 

	^ self new buildFrom: aNode
]

{ #category : #'as yet unclassified' }
SBStateMachine >> addUponEnter: aBlock [

	self addMorphBack: aBlock
]

{ #category : #initialization }
SBStateMachine >> buildFrom: aNode [

	SBExample
		self: [SBStateMachine new]
		args: [
			{
				'TOMStateMachine new
		initialState: #idle;
		
		from: #idle to: #combat if: [ self checkNearbyEnemies ];
		from: #combat to: #idle if: [ self target isNil ];
		from: #combat to: #idle when: #finished' parseAsSandblockWithoutSubstitution
			}]
		label: 'simple'.
	states := Dictionary newFrom: (((aNode messages gather: [:message | 
		message selector caseOf: {
			([#from:to:if:] -> [message arguments copyFrom: 1 to: 2]).
			([#from:to:when:] -> [message arguments copyFrom: 1 to: 2]).
			([#from:to:after:] -> [message arguments copyFrom: 1 to: 2]).
			([#initialState:] -> [{message arguments first}]).
			([#uponEnter:do:] -> [{message arguments first}]).
			([#uponLeave:do:] -> [{message arguments first}]).
			([#yourself] -> [{}])
		}]) asSet collect: #contents) collect: [:name | name -> (SBStateMachineState new name: name)]).
	states do: [:state | self addMorphBack: state].
	connectors := OrderedCollection new.
	aNode messages do: [:message | 
		message selector caseOf: {
			([#initialState:] -> [initialState := states at: message arguments first contents]).
			([#from:to:if:] -> [ | line |
				self
					connect: message arguments first contents
					to: message arguments second contents
					if: message arguments third]).
			([#from:to:when:] -> [ | line |
				self
					connect: message arguments first contents
					to: message arguments second contents
					if: message arguments third]).
			([#from:to:after:] -> [ | line |
				self
					connect: message arguments first contents
					to: message arguments second contents
					if: message arguments third]).
			([#uponEnter:do:] -> [(states at: message arguments first contents) addUponEnter: message arguments second]).
			([#uponLeave:do:] -> [(states at: message arguments first contents) addUponLeave: message arguments second]).
			([#yourself] -> [nil])
		}].
	self updatePositions
]

{ #category : #'as yet unclassified' }
SBStateMachine >> childSandblocksDo: aBlock [

	states do: [:state | aBlock value: state].
	connectors do: [:transition | transition conditions do: [:condition | aBlock value: condition]]
]

{ #category : #'as yet unclassified' }
SBStateMachine >> connect: aStateName to: anotherStateName if: aBlock [

	| line |
	line := connectors
		detect: [:transition | transition from name = aStateName and: [transition to name = anotherStateName]]
		ifFound: #yourself
		ifNone: [SBStateMachineTransition connect: (states at: aStateName) to: (states at: anotherStateName)].
	line addCondition: aBlock.
	self addMorphBack: line.
	^ connectors add: line
]

{ #category : #'as yet unclassified' }
SBStateMachine >> drawnColor [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBStateMachine >> example [

	SBMorphExample
		setUp: [SBEditor newFor: SBStateMachine >> #exampleStateMachine]
		cases: {(SBMorphExampleCase name: 'example 1' caseBlock: [:e | e])}
		extent: 535 @ 537
]

{ #category : #'as yet unclassified' }
SBStateMachine >> exampleStateMachine [

	| a b |
	super initialize.
	a := 5.
	b := SBStateMachine new
		initialState: #idle;
		uponEnter: #evasion do: [self flattenOnStream: a];
		uponEnter: #combat do: [self yourself];
		uponLeave: #combat do: [self stop];
		from: #idle to: #combat if: [self checkNearbyEnemies];
		from: #combat to: #evasion if: [self checkLowHealth];
		from: #evasion to: #idle if: [true]
]

{ #category : #'as yet unclassified' }
SBStateMachine >> initialState [

	^ initialState
]

{ #category : #'as yet unclassified' }
SBStateMachine >> initialState: aState [

	previous := initialState.
	initialState := aState.
	aState layoutChanged.
	previous layoutChanged
]

{ #category : #'as yet unclassified' }
SBStateMachine >> initialize [

	super initialize.
	self extent: 300 @ 300.
	self layoutInset: 6 withScalingFactor.
	self vResizing: #shrinkWrap.
	self hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBStateMachine >> minExtent [

	| area |
	area := Rectangle merging: self submorphs.
	^ area extent + (area origin - self position)
]

{ #category : #'as yet unclassified' }
SBStateMachine >> states [

	^ states
]

{ #category : #'as yet unclassified' }
SBStateMachine >> updatePositions [

	| increment |
	increment := 360 / states size.
	states doWithIndex: [:state :index | state position: (Point r: 100 degrees: (increment - 1) * index) + (self extent / 2)]
]

{ #category : #'as yet unclassified' }
SBStateMachine >> writeSourceOn: aStream [

	SBExample
		self: [SBStateMachine new buildFrom: 'SBStateMachine new
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
	connectors do: [:transition | 
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
