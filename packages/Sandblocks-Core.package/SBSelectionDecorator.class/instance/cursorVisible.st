as yet unclassified
cursorVisible

	^ cursorShown or: [self morph sandblockEditor hasKeyboardFocus not or: [blinkCount >= self maxBlickCount]]