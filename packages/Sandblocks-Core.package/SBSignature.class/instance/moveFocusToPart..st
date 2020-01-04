as yet unclassified
moveFocusToPart: aMorph

	currentInputMessagePart stopEditing.
	currentInputMessagePart := aMorph.
	currentInputMessagePart moveCursorTo: 1