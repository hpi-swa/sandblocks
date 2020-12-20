as yet unclassified
exampleStateMachine

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