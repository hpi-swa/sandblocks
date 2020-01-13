as yet unclassified
suggestion

	^ [:block | block sandblockEditor do: ((SBReplaceCommand newFor: block containingArtefact)
		target: block;
		replacer: (SBMorphExample new setUp: SBBlockBody empty cases: {} extent: 100 asPoint))]