as yet unclassified
replaceWithPragma

	| pragma |
	pragma := SBPragma new.
	self stopEditing.
	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
		target: self;
		replacer: pragma;
		shouldMergeWithNext: true).
	^ pragma sandblockEditor startInput: pragma at: 1 replacingContents: true