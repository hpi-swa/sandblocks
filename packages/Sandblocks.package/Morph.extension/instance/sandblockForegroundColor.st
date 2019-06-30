*Sandblocks
sandblockForegroundColor

	^ self containingSandblock color luminance > 0.6 ifTrue: [Color black] ifFalse: [Color white]