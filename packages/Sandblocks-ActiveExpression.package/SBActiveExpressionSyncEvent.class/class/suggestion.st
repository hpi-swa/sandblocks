as yet unclassified
suggestion

	^ [:block | block sandblockEditor do: ((SBReplaceCommand newFor: block containingArtefact)
		target: block;
		replacer: (SBActiveExpressionSyncEvent new expression: SBUnknown new))]