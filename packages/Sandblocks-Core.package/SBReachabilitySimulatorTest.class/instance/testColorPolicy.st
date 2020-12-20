as yet unclassified
testColorPolicy

	| editor method nestedSend compiledMethod |
	compiledMethod := SBReachabilitySimulatorTest >> #exampleColorPolicy.
	method := compiledMethod asSandblock.
	editor := self editorFor: method.
	nestedSend := method body statements second arguments first statements first.
	
	method body statements first showReachability.
	self assert: (editor colorPolicy wasReached: nestedSend)