as yet unclassified
mouseMove: anEvent

	cuttingMoving
		ifTrue: [self links do: [:link |
				(link source center
					to: link target center
					intersects: anEvent startPoint
					to: anEvent endPoint) ifTrue: [link delete]]]
		ifFalse: [super mouseMove: anEvent]