as yet unclassified
exampleStateMachine

	SBStateMachine new
		initialState: #idle;
		uponEnter: #evasion do: [self flattenOnStream: 2];
		uponEnter: #combat do: [self combat];
		uponLeave: #combat do: [self combat];
		from: #idle to: #combat if: [self checkNearbyEnemies];
		from: #combat to: #evasion if: [self checkLowHealth];
		from: #evasion to: #idle if: [true];
		yourself