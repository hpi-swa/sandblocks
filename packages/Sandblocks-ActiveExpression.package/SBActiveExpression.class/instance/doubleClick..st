as yet unclassified
doubleClick: anEvent

	(SBExample getAllInMethod: self containingMethod) do: [:example | | results |
		results := Array streamContents: [:stream |
			VarTra activeInstVarSubscriptionsBindings do: [:binding |
				binding value at: example currentSelf ifPresent: [:list | list do: [:ae | ae monitoredBlock endPC = (self pc - 1) ifTrue: [stream nextPut: (binding key -> ae)]]]]].
		results explore]