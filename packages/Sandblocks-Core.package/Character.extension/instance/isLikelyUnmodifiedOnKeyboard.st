*Sandblocks-Core
isLikelyUnmodifiedOnKeyboard

	^ self asInteger >= 32 and: [self asInteger < 255 and: [self asInteger ~= 127]]