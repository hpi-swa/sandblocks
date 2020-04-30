as yet unclassified
exampleStateMachine

	| a |
	super initialize.
	a := 5.
	SBStateMachine new
		initialState: #idle;
		uponEnter: #evasion do: [self flattenOnStream: a];
		uponEnter: #combat do: [self combat];
		uponLeave: #combat do: [self stop];
		from: #idle to: #combat if: [self checkNearbyEnemies];
		from: #combat to: #evasion if: [self checkLowHealth];
		from: #evasion to: #idle if: [true]