Class {
	#name : #SBStateMachineEditor,
	#superclass : #SBStSubstitution,
	#instVars : [
		'connectors',
		'initialState',
		'previous'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #suggestions }
SBStateMachineEditor class >> instanceSuggestion [

	^ [SBStateMachineEditor new]
]

{ #category : #testing }
SBStateMachineEditor class >> matches: aNode [

	(super matches: aNode) ifFalse: [^ false].

	^ aNode isCascade and: [aNode receiver isMessageSend and: [aNode receiver receiver isName and: [aNode receiver receiver contents = 'SBStateMachine' and: [aNode receiver selector = 'new']]]]
]

{ #category : #testing }
SBStateMachineEditor class >> matchesCascades [

	^ true
]

{ #category : #'instance creation' }
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
			[#from:to:if:] -> [message arguments copyFrom: 1 to: 2].
			[#from:to:when:] -> [message arguments copyFrom: 1 to: 2].
			[#from:to:after:] -> [message arguments copyFrom: 1 to: 2].
			[#initialState:] -> [{message arguments first}].
			[#uponEnter:do:] -> [{message arguments first}].
			[#uponLeave:do:] -> [{message arguments first}].
			[#start] -> [{}].
			[#yourself] -> [{}]
		}]) collect: #contents) withoutDuplicates collect: [:name | name -> (SBStateMachineState new name: name)]).
	states do: [:state | self addMorphBack: state].
	aNode messages do: [:message |
		message selector caseOf: {
			[#initialState:] -> [initialState := states at: message arguments first contents].
			[#from:to:if:] -> [
				self
					connect: message arguments first contents
					to: message arguments second contents
					type: #condition
					data: message arguments third veryDeepCopy].
			[#from:to:when:] -> [
				self
					connect: message arguments first contents
					to: message arguments second contents
					type: #signal
					data: message arguments third veryDeepCopy].
			[#from:to:after:] -> [
				self
					connect: message arguments first contents
					to: message arguments second contents
					type: #time
					data: message arguments third veryDeepCopy].
			[#uponEnter:do:] -> [(states at: message arguments first contents) addUponEnter: message arguments second veryDeepCopy].
			[#uponLeave:do:] -> [(states at: message arguments first contents) addUponLeave: message arguments second veryDeepCopy].
			[#yourself] -> [nil].
			[#start] -> [nil]
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
SBStateMachineEditor >> connect: aStateName to: anotherStateName type: aSymbol data: aBlock [

	| line connectors |
	connectors := self connectors.
	line := connectors
		detect: [:transition | transition from name = aStateName and: [transition to name = anotherStateName]]
		ifFound: #yourself
		ifNone: [
			SBStateMachineTransition connect: (self stateNamed: aStateName) to: (self stateNamed: anotherStateName)].
	connectors
		detect: [:transition | transition to name = aStateName and: [transition from name = anotherStateName]]
		ifFound: [:transition |
			transition evade: #right.
			line evade: #right].
	line addCondition: (SBStateMachineTransitionCondition new type: aSymbol data: aBlock).
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
SBStateMachineEditor >> drawBackgroundOn: aCanvas [

	aCanvas
		frameAndFillRoundRect: self bounds
		radius: 10
		fillStyle: self drawnColor
		borderWidth: (self colorPolicy borderWidthForBlock: self)
		borderColor: (self colorPolicy borderColorForBlock: self)
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
	
	b := SBStateMachine new
		initialState: #idle;
		uponEnter: #evasion do: [a accelerate];
		uponLeave: #evasion do: [self stop];
		uponEnter: #combat do: [a startShooting];
		uponLeave: #combat do: [a stopShooting];
		from: #idle to: #combat if: [self checkNearbyEnemies];
		from: #idle to: #combat if: [self changed];
		from: #combat to: #evasion if: [self checkLowHealth];
		from: #evasion to: #idle if: [true];
		from: #combat to: #combat if: [self isMorph];
		start
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
	previous ifNotNil: #layoutChanged
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> initialize [

	super initialize.
	self extent: 300 @ 300.
	self layoutInset: 6.
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

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> minExtent [

	| area |
	self hasSubmorphs ifFalse: [^ 100 asPoint].
	area := Rectangle merging: self submorphs.
	^ area extent + self layoutInset asEdgeInsets
]

{ #category : #initialization }
SBStateMachineEditor >> newEmptyChildNear: aBlock before: aBoolean [

	^ SBStateMachineState new
		name: '';
		position: self position + (30 @ 30)
]

{ #category : #'as yet unclassified' }
SBStateMachineEditor >> objectInterfaceNear: aBlock at: aSymbol [

	aSymbol = #replace ifTrue: [^ SBInterfaces never].
	
	^ {#isSandblock. [:obj | obj isKindOf: SBStateMachineState]}
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
		self: [
			SBStateMachineEditor new buildFrom: 'SBStateMachine new
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
			condition writeSourceOn: aStream]].
	aStream nextPutAll: '; start)'
]
