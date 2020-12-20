*Sandblocks-Core
atPingPong: aNumber

	| index |
	SBExample self: [{1. 2. 3. 4}] args: [{5}] label: 'example'.
	SBExample self: [{1. 2. 3. 4}] args: [{16}] label: 'example 2'.
	
	index := ((aNumber - 1) \\ ((self size * 2) - 2)) + 1.
	
	^ self at: (index > self size ifTrue: [(self size * 2) - index] ifFalse: [index])