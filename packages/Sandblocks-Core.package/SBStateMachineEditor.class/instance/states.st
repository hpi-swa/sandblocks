as yet unclassified
states

	^ OrderedDictionary newFrom: (self submorphs select: [:morph | morph isKindOf: SBStateMachineState] thenCollect: [:state | state name asSymbol -> state])