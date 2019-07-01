as yet unclassified
moveFocusToNextPart: aNumber

	currentInputMessagePart stopEditing.
	currentInputMessagePart := self submorphs atWrap: (self submorphIndexOf: currentInputMessagePart) + (2 * aNumber).
	currentInputMessagePart moveCursorTo: 1