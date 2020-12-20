actions
wrapInArrayType: aSymbol

	self assert: self isSelected.
	self sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	self sandblockEditor doMultiSelection: [:selected |
		(SBWrapConsecutiveCommand newFor: self containingArtefact)
			outer: SBArray new;
			targets: selected;
			wrap: [:outer :inner | outer type: aSymbol contents: inner];
			yourself]