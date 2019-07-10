as yet unclassified
moveFocusToNextPart: aNumber

	((self arguments notEmpty and: [self submorphCount <= 2]) or: [currentInputMessagePart submorphAfter isUnknown])
		ifTrue: [ | arg |
			arg := currentInputMessagePart submorphAfter.
			self containingSandblock sandblockEditor
				endInput;
				startInput: arg at: 0 replacingContents: false]
		ifFalse: [self moveFocusToPart: (self submorphs atWrap: (self submorphIndexOf: currentInputMessagePart) + (2 * aNumber))]