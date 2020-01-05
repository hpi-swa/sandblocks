as yet unclassified
tileAt: aPoint 
	^ (aPoint x < 1
			or: [aPoint y < 1
					or: [aPoint x > self fieldSize
							or: [aPoint y > self fieldSize]]])
		ifFalse: [self submorphs at: aPoint y - 1 * self fieldSize + aPoint x]