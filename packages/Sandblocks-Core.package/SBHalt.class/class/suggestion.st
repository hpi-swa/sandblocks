as yet unclassified
suggestion

	^ [:block | block sandblockEditor do: ((SBReplaceCommand newFor: block containingArtefact)
		target: block;
		replacer: SBHalt new)]