actions
wrapInToggledCode
	<multiSelectAction>

	| comment |
	self assert: self isSelected.
	comment := SBToggledCode new.
	self sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	self sandblockEditor doMultiSelection: [:selected |
		(SBWrapConsecutiveCommand newFor: self containingArtefact)
			outer: comment;
			targets: selected;
			wrap: [:outer :inner | outer comment: '' active: 0 do: {SBBlockBody new statements: inner}];
			yourself]