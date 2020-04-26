as yet unclassified
writeSourceOn: aStream

	SBExample
		self: [SBStateMachine new buildFrom: 'TOMStateMachine new
		initialState: #idle;
		
		uponEnter: #combat do: [ self combat ];
		from: #idle to: #combat if: [ self checkNearbyEnemies ];
		from: #combat to: #idle if: [ self target isNil ]' parseAsSandblockWithoutSubstitution]
		args: [{'' writeStream}]
		label: 'simple'.
	aStream
		nextPut: $(;
		nextPutAll: 'TOMStateMachine';
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