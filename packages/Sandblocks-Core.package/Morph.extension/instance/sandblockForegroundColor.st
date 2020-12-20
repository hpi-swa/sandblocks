*Sandblocks-Core
sandblockForegroundColor

	^ self containingSandblock ifNotNil: [:b | b foregroundColor] ifNil: [color]