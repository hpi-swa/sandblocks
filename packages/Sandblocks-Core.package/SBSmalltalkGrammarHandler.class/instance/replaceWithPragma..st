as yet unclassified
replaceWithPragma: aBlock

	| pragma |
	pragma := SBPragma new.
	aBlock stopEditing.
	aBlock sandblockEditor do: ((SBReplaceCommand newFor: aBlock containingArtefact)
		target: aBlock;
		replacer: pragma;
		shouldMergeWithNext: true).
	^ pragma sandblockEditor startInput: pragma at: 1 replacingContents: true