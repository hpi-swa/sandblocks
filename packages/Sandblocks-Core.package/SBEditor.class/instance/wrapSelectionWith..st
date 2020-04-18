actions
wrapSelectionWith: aSelection

	| around new |
	around := self selection.
	new := aSelection veryDeepCopy.
	
	self do: (SBCombinedCommand newWith: {
		(SBReplaceCommand newFor: self selectedArtefact)
			target: around;
			replacer: new firstSubmorph.
		(SBReplaceCommand newFor: self selectedArtefact)
			target: new placeholder;
			replacer: around.
	}).
	
	new postDuplicate