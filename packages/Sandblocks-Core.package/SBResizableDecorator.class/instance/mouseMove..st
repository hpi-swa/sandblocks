as yet unclassified
mouseMove: anEvent

	(self relevantPosition: anEvent) ifTrue: [Cursor resizeBottomRight show] ifFalse: [Cursor normal show]