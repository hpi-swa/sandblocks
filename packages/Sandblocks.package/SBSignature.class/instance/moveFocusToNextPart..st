as yet unclassified
moveFocusToNextPart: aNumber

	self moveFocusToPart: (self submorphs atWrap: (self submorphIndexOf: currentInputMessagePart) + (2 * aNumber))