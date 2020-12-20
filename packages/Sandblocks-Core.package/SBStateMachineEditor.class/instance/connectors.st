as yet unclassified
connectors

	^ self submorphs select: [:morph | morph isKindOf: SBStateMachineTransition]