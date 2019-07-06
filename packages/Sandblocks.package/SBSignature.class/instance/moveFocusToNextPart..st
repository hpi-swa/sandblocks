as yet unclassified
moveFocusToNextPart: aNumber

	(self arguments notEmpty and: [self submorphCount <= 2])
		ifTrue: [
			self containingSandblock sandblockEditor
				endInput;
				startInput: self arguments first at: 0 replacingContents: false]
		ifFalse: [self moveFocusToPart: (self submorphs atWrap: (self submorphIndexOf: currentInputMessagePart) + (2 * aNumber))]