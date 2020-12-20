actions
wrapInBlock
	<multiSelectAction>
	<actionValidIf: #isExpression>

	self assert: self isSelected.
	self sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	self sandblockEditor doMultiSelection: [:selected |
		(SBWrapConsecutiveCommand newFor: self containingArtefact)
			outer: SBBlockBody new;
			targets: selected;
			wrap: [:outer :inner | outer statements: inner];
			yourself]