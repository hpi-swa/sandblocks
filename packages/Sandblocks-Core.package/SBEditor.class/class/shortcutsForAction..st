initialize-release
shortcutsForAction: anAction

	^ self shortcuts select: [:assoc | assoc value = anAction] thenCollect: [:assoc | assoc key]