*Sandblocks-Core
focusNextMorph: anEvent

	anEvent hand newKeyboardFocus: (self nextMorphThat: [:m | m wantsKeyboardFocus])