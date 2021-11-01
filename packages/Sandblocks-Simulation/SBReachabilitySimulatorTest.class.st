Class {
	#name : #SBReachabilitySimulatorTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Simulation'
}

{ #category : #accessing }
SBReachabilitySimulatorTest >> exampleColorPolicy [

	| a |
	SBExample self: [SBReachabilitySimulatorTest new] args: [{}] label: 'example'.
	#(21) do: [:num | 5 squared]
]

{ #category : #accessing }
SBReachabilitySimulatorTest >> exampleMethod [

	| a |
	#(21) do: [:num | 5 squared].
	5 > 2 ifTrue: [Transcript showln: 'Hello'] ifFalse: [Transcript showln: 'Bye'].
	a := 5 squared
]

{ #category : #tests }
SBReachabilitySimulatorTest >> testColorPolicy [

	| editor method nestedSend compiledMethod |
	compiledMethod := SBReachabilitySimulatorTest >> #exampleColorPolicy.
	method := compiledMethod asSandblock.
	editor := self methodFor: method.
	nestedSend := method body statements second arguments first statements first.
	
	method body statements first showReachability.
	self assert: (editor colorPolicy wasReached: nestedSend)
]

{ #category : #tests }
SBReachabilitySimulatorTest >> testReachability [

	| policy m |
	m := SBReachabilitySimulatorTest >> #exampleMethod.
	m encoderClass supportsFullBlocks ifFalse: [^ self].
	
	policy := SBReachabilityColorPolicy new.
	SBStReachabilitySimulator new
		store: policy;
		runSimulated: [self exampleMethod].
	
	self assert: (policy reached: 101 in: m) description: 'Loop starter'.
	self assert: (policy reached: (m literalAt: 2) -> 35 in: m) description: 'Send in loop'.
	self assert: (policy reached: 111 in: m) description: 'True case'.
	self deny: (policy reached: 115 in: m) description: 'True case'.
	self assert: (policy reached: 120 in: m) description: 'Assignment'
]
