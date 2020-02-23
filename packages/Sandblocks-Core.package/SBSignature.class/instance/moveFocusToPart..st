as yet unclassified
moveFocusToPart: aMorph

	currentInputMessagePart stopEditing.
	currentInputMessagePart := aMorph.
	
	" place cursor in front of colon (behind doesn't make sense) or append "
	currentInputMessagePart moveCursorTo: (currentInputMessagePart contents = ':' ifTrue: [0] ifFalse: [9e8])