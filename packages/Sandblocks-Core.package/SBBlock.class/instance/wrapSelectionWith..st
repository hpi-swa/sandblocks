as yet unclassified
wrapSelectionWith: aSelection

	self sandblockEditor doMultiSelection: [:selected |
		(SBRecordedCommand newFor: self containingArtefact) record: [:recorder | | new placeholder |
			new := aSelection veryDeepCopy.
			placeholder := new placeholder.
			recorder replace: selected first with: new firstSubmorph.
			recorder replace: placeholder with: selected first.
			recorder moveAll: selected allButFirst after: selected first]].
	
	self parentSandblock postDuplicate