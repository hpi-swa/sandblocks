*Sandblocks-Core
matchesEvent: anEvent

	^ self anySatisfy: [:shortcut | shortcut matchesEvent: anEvent]