actions
wrapInCascade
	<multiSelectAction>

	| cascade |
	self assert: self isSelected.
	cascade := SBCascade new.
	self sandblockEditor doMultiSelection: [:selected | | targets |
		targets := selected collect: #messageSend.
		(self sandblockEditor submorphsAreConsecutive: targets)
			ifFalse: [nil]
			ifTrue: [
				(SBWrapConsecutiveCommand newFor: self containingArtefact)
					targets: (selected collect: #messageSend);
					outer: SBCascade new;
					wrap: [:outer :inner |
						outer addMorphFront: inner first receiver.
						outer addAllMorphs: inner];
					wrapUndo: [:outer :inner |
						inner do: [:message | message receiver: outer receiver veryDeepCopy].
						outer removeAllMorphs]]]