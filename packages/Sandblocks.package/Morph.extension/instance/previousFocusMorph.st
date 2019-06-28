*Sandblocks
previousFocusMorph

	^ self previousAdjacentFocusMorph ifNil: [self owner previousFocusMorph]